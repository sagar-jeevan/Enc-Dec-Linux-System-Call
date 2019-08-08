// SPDX-License-Identifier: GPL-2.0

#include <linux/linkage.h>
#include <linux/moduleloader.h>
#include <linux/fs.h>
#include <linux/dcache.h>
#include <linux/atomic.h>
#include <linux/slab.h>
#include <linux/scatterlist.h>
#include <linux/uaccess.h>
#include <linux/string.h>
#include <linux/mutex.h>
#include <crypto/internal/skcipher.h>
#include <crypto/hash.h>
#include <linux/crypto.h>
#include <linux/cred.h>
#include <linux/stat.h>

/*
 * newly created file, which includes a structure.
 * contains input, output filenames with other additional arguments.
 */

#include "io_filenames.h"

/* the read & write buffer */
char *rw_buffer;
unsigned char ivdata[16];

asmlinkage extern long (*sysptr)(void *arg);

/*
 * int MD5_hash(char *user_key, int user_keylen, char *digest_hash_key)
 * {
 * int retval = 0;
 * struct crypto_shash *shash_crypto;
 *
 * shash_crypto = crypto_alloc_shash("md5", 0, CRYPTO_ALG_ASYNC)
 *
 * SHASH_DESC_ON_STACK(desc, tfm);
 *
 * if (!shash_crypto || IS_ERR(shash_crypto)) {
 * retval = (int)PTR_ERR(shash_crypto);
 * return retval;
 * }
 * desc->tfm = shash_crypto;
 * desc->flags = 0;
 * retval = crypto_shash_digest(desc, user_key,
 * user_keylen, digest_hash_key);
 * shash_desc_zero(desc);
 * crypto_free_shash(shash_crypto);
 * return retval;
 * }
 */

struct skcipher_def {
	struct scatterlist sg;
	struct crypto_skcipher *tfm;
	struct skcipher_request *req;
	struct crypto_wait wait;
};

/* Perform cipher operation */
static unsigned int test_skcipher_encdec(struct skcipher_def *sk, int enc)
{
	int rc;

	if (enc & 0x1)
		rc = crypto_wait_req(crypto_skcipher_encrypt(sk->req),
		&sk->wait);
	else
		rc = crypto_wait_req(crypto_skcipher_decrypt(sk->req),
		&sk->wait);
	if (rc)
		pr_info("skcipher encrypt returned with result %d\n", rc);
	return rc;
}


/* Initialize, trigger cipher operation */
static int test_skcipher(unsigned char *md, int ED_flag,
unsigned long inode_number)
{
	struct skcipher_def sk;
	struct crypto_skcipher *skcipher = NULL;
	struct skcipher_request *req = NULL;
	int ret = -EFAULT;

	skcipher = crypto_alloc_skcipher("ctr(aes)", 0, 0);
	if (IS_ERR(skcipher)) {
		pr_info("could not allocate skcipher handle\n");
		return PTR_ERR(skcipher);
	}

	req = skcipher_request_alloc(skcipher, GFP_KERNEL);
	if (!req) {
		pr_info("could not allocate skcipher request\n");
		ret = -ENOMEM;
		goto out;
	}

	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
	crypto_req_done, &sk.wait);

	if (crypto_skcipher_setkey(skcipher, md, 32)) {
		pr_info("key could not be set\n");
		ret = -EAGAIN;
		goto out;
	}
	sk.tfm = skcipher;
	sk.req = req;

	/* We encrypt one block */
	sg_init_one(&sk.sg, rw_buffer, 16);
	skcipher_request_set_crypt(req, &sk.sg, &sk.sg, 16, ivdata);
	crypto_init_wait(&sk.wait);

	/* encrypt data */
	ret = test_skcipher_encdec(&sk, ED_flag);
	if (ret)
		goto out;

out:
	if (skcipher)
		crypto_free_skcipher(skcipher);
	if (req)
		skcipher_request_free(req);
	return ret;
}

asmlinkage long cpenc(void *arg)
{
	int stat_return, ret, return_value = 0;
	int ret_unlink, iv_length = 16, write_size = 16, total_rem = 0;
	struct inode *i_inode, *o_inode;
	mm_segment_t oldFs;
	unsigned int current_uid, current_gid;
	Files *files;
	struct file *fd_input, *fd_output;
	ssize_t r_input, w_output;
	bool unlink_flag = false, EOF_flag = false;
	struct inode *parent_inode;
	struct dentry *file_dentry;
	struct filename *i_files, *o_files;
	struct kstat *input_stat;
	umode_t input_mode;

	files = kmalloc(sizeof(Files), GFP_KERNEL);
	if (!files)
		return -EFAULT;

	input_stat = kmalloc(sizeof(struct kstat), GFP_KERNEL);
	if (!input_stat) {
		return_value = -ENOMEM;
		goto out;
	}

	/* copy user space structure to kernel space */
	ret = copy_from_user(files, arg, sizeof(Files));
	if (ret) {
		return_value = -ENOMEM;
		goto out;
	}

	/* check if received arguments from user is not NULL */
	if (files == NULL) {
		pr_err("The received arguments from the user is NULL\n");
		return_value = -EINVAL;
		goto arg_error;
	}

	/* check if the received input file from the user is not NULL */
	if (files->input == NULL) {
		pr_err("The received input file from the user is NULL\n");
		return_value = -EINVAL;
		goto arg_error;
	}

	/* check if the received output file from the user is not NULL */
	if (files->output == NULL) {
		pr_err("The received output file from the user is NULL\n");
		return_value = -EINVAL;
		goto arg_error;
	}

	/* check if the received hash from the user is not NULL */
	if (files->hash == NULL) {
		pr_err("The received hash (password) from the user is NULL\n");
		return_value = -EINVAL;
		goto arg_error;
	}

	/* check if the received key length from the user is valid */
	if (files->key_length < 16 || files->key_length > 32) {
		/* set default key length */
		files->key_length = 32;
	}

	/* check if the received buffer block size from the user is valid */
	if (files->ED_unit < 1)
		/* set default buffer block size */
		files->ED_unit = write_size;

	/* get the input file name from user space to kernel space */
	i_files = getname(((Files *) arg)->input);

	/* check if the return of getname is a valid input file or not */
	if (IS_ERR(i_files)) {
		pr_err("File Error: input file name, or location is not valid\n");
		return_value = -ENOENT;
		goto arg_error;
	}

	/* get the output file name from user space to kernel space */
	o_files = getname(((Files *) arg)->output);

	/* check if the return value of getname is a valid output file or not */
	if (IS_ERR(o_files)) {
		pr_err("File Error: output file name, or location is not valid\n");
		return_value = -ENOENT;
		goto arg_error;
	}

	/* get the stat of input file */
	stat_return = vfs_stat(files->input, input_stat);

	/* assign current_uid to the uid of the current process' uid.
	 * assign current_gid to the gid of the current process' gid.
	 */

	/*
	 * compare the credentials of current process with file credentials.
	 * if they match, it means the same user had created the file.
	 * else, throw an error: permission denied.
	 */

	/* This is the UID, and GID of current process */
	current_uid = (unsigned int) current->cred->uid.val;
	current_gid = (unsigned int) current->cred->gid.val;

	/* don't allow other users to access the encrypted or plain file */
	if (!(current_uid == input_stat->uid.val ||
	current_gid == input_stat->gid.val)) {
		return_value = -EACCES;
	}

	/*
	 * open the input file in READ ONLY mode.
	 * file permissions are ignored since the file is alredy created.
	 */
	fd_input = filp_open(i_files->name, O_RDONLY, 0);

	/* check if filp open has successfully opened input file or not */
	if (IS_ERR(fd_input)) {
		pr_err("File Error: input file could not be opened\n");
		return_value = -ENOENT;
		goto arg_error;
	}

	/*
	 * dynamically allocate buffer.
	 * memory needed will exceed stack frame if buffer size is high.
	 * rw_buffer is a read/write buffer.
	 */
	rw_buffer = kmalloc(write_size, GFP_KERNEL);

	/*
	 * the output file is opened if it already exists, else it is created.
	 * opened in WRITE ONLY mode.
	 */

	input_mode = input_stat->mode;
	fd_output = filp_open(o_files->name, O_WRONLY | O_CREAT, 0771);

	/* check if filp open has succesfully opened output file or not */
	if (IS_ERR(fd_output)) {
		pr_err("File Error: output file could not be opened\n");
		return_value = -ENOENT;
		goto arg_error;
	}

	/*
	 * check if input file is same as output. if so, return error.
	 * filp_open tracks down any given symbolic link to the root file.
	 * check if input file is a regular file, if not return error.
	 * check if output file is a regular file, if not return error.
	 */

	i_inode = fd_input->f_path.dentry->d_inode;
	o_inode = fd_output->f_path.dentry->d_inode;
	if (!(S_ISREG(i_inode->i_mode) &&
	(S_ISREG(o_inode->i_mode))) || (i_inode == o_inode)) {
		return_value = -EINVAL;
		goto vfs_error;
	}

	/* set output file ownership to current running process creds */
	o_inode->i_uid.val = current_uid;
	o_inode->i_gid.val = current_gid;

	oldFs = get_fs();
	set_fs(KERNEL_DS);

	/*
	 * condition to check if the user is trying to encrypt or decrypt.
	 * if (files->EDC_flag & x02 == 1) decrypt!
	 * else if (files->EDC_flag & x01 == 1) encrypt!
	 */
	if (files->EDC_flag & 0x2) {
		/* reset the read offset of the input file */
		fd_input->f_pos = 0;

		/* read first 32 bytes of encrypted file to get hashed key */
		vfs_read(fd_input, rw_buffer, 32, &(fd_input->f_pos));

		/*
		 * compare if retrieved hash is same as hash of user password
		 * memcmp will check n blocks of memory (files->hash,rw_buffer)
		 */

		if (memcmp(files->hash, rw_buffer, 32) != 0) {
			return_value = -EACCES;	// no access permission
			goto vfs_error;
		}
	} else if (files->EDC_flag & 0x1) {
		/* reset the write offset of the input file */
		fd_output->f_pos = 0;

		/* write hash of key into preamble of output file */
		vfs_write(fd_output, files->hash, 32, &(fd_output->f_pos));
	}

	/* setting the write size equal to user specified unit size */
	do {
		if (files->EDC_flag & 0x1) {
			get_random_bytes(&ivdata, iv_length);
			w_output = vfs_write(fd_output, ivdata,
			iv_length, &(fd_output->f_pos));
		} else if (files->EDC_flag & 0x2) {
			r_input = vfs_read(fd_input, ivdata,
			iv_length, &(fd_input->f_pos));
		}

		/*
		 * read the file into the temporary buffer (rw_buffer).
		 * on success, vfs_read returns number of bytes read.
		 * on failure, vfs_read returns a negative number.
		 */
		r_input = vfs_read(fd_input, rw_buffer,
		write_size, &(fd_input->f_pos));

		/* keep count of total bytes remaining to read */
		total_rem = total_rem - r_input;

		/*
		 * if return value of vfs_read < 0, exit program (error).
		 * if remaining bytes > 0 and r_input < write_size, error.
		 */

		if (r_input < 0 || (total_rem > 0 && r_input < write_size)) {
			return_value = r_input; /* assign the return value */
			goto vfs_error;
		}

		/* if r_input < write_size, f_pos has reached the EOF.
		 * This is the last block of the file.
		 */

		if (r_input < write_size) {
			/* a flag to stop the next iteration of do while loop */
			EOF_flag = true;
			write_size = r_input;
		}

		/*
		 * having read contents into rw_buffer, encrypt/decrypt block.
		 * test_skcipher returns encrypted data of buffer contents.
		 * ED_flag indicates encryption or decryption.
		 */
		if (!(files->EDC_flag & 0x4))
			test_skcipher(files->hash,
			files->EDC_flag, i_inode->i_ino);

		/* write the encrypted/decrypted buffer to an output file */
		w_output = vfs_write(fd_output, rw_buffer,
		write_size, &(fd_output->f_pos));

		/* if w_output < zero, exit program with error message */
		if (w_output < 0) {
			return_value = w_output; /* assign the return value */
			goto vfs_error;
		}

	} while (!EOF_flag);

	/* change the permission mode of output file same as input file */
	fd_output->f_path.dentry->d_inode->i_mode = input_stat->mode;

	if (EOF_flag)
		goto out;

	/*
	 * handle scenario where either vfs_read, vfs_write returns an error.
	 * unlink the partially created output file.
	 */
vfs_error:
		/* file (victim) dentry object */
		file_dentry = fd_output->f_path.dentry;

		/* parent inode of the victim (output) file */
		parent_inode = fd_output->f_path.dentry->d_parent->d_inode;

		/* close the ouput file before unlinking from the inode */
		filp_close(fd_output, 0);

		/* set unlink_flag to 1, to indicate file is closed */
		unlink_flag = true;

		/*
		 * vfs_unlink unlinks the filesysttem object from the inode.
		 * takes a pointer of parent inode, file dentry.
		 * returns ... on success, and ... on failure.
		 */

		/* remove the partially created output file */
		ret_unlink = vfs_unlink(parent_inode, file_dentry, NULL);

		/* if vfs_unlink returns an error, handle it */
		if (ret_unlink < 0)
			return_value = -EBUSY;
out:
		/* set back to old data segment */
		set_fs(oldFs);

		/* close any open files using filp_close */
		filp_close(fd_input, 0);

		/* if unlink_flag is set, the file has already been closed */
		if (!unlink_flag)
			filp_close(fd_output, 0);

arg_error:
		/*
		 * free dynamically allocated memory.
		 * memory leaks will happen if memory is not freed.
		 */
		kfree(files);
		kfree(rw_buffer);
		kfree(input_stat);

		/*
		 * if arguments passed from userspace is NULL, return -EINVAL.
		 * else return the value of return_val.
		 * by default return_value contains 0 to indicate success.
		 */
		if (arg == NULL)
			return -EINVAL;
		else
			return return_value;
}

static int __init init_sys_cpenc(void)
{
	// printk("installed new sys_cpenc module\n");
	if (sysptr == NULL)
		sysptr = cpenc;
	return 0;
}
static void  __exit exit_sys_cpenc(void)
{
	if (sysptr != NULL)
		sysptr = NULL;
	// printk("removed sys_cpenc module\n");
}

module_init(init_sys_cpenc);
module_exit(exit_sys_cpenc);

MODULE_LICENSE("GPL");
