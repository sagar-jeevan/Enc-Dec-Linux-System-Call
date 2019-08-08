// SPDX-License-Identifier: GPL-2.0

#include <asm/unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <string.h>
#include <openssl/sha.h>
#include <stdbool.h>
#include <sys/stat.h>

/* custom header - contains a structure with user parameters */
#include "io_filenames.h"

#ifndef __NR_cpenc
#error cpenc system call not defined
#endif

/*
 * generate a SHA256 hash value for the given user password.
 * returns true if SHA256 has is successfully generated, else false.
 */
bool simpleSHA256(void *password, unsigned long length,
unsigned char *SHA256_digest)
{
	SHA256_CTX SHA_handle;

	if (!SHA256_Init(&SHA_handle))
		return false;
	if (!SHA256_Update(&SHA_handle, (unsigned char *) password, length))
		return false;
	if (!SHA256_Final(SHA256_digest, &SHA_handle))
		return false;
	return true;
}

/*
 * check if the directory path of the given file is valid.
 * returns 0 on if it's valid, else appropriate error.
 */
int dir_isvalid(char *directory)
{
	int return_value = 0, path_count = 0, i = strlen(directory) - 1;
	char *dir_buffer;
	struct stat dir_stat;

	/* get the full path of the directory in which the file exists */
	while (true) {
		/* traverse directory path from end until you find '/' */
		if (directory[i] == '/') {
			path_count = i;
			break;
		}
		i = i - 1;
	}

	dir_buffer = malloc(sizeof(path_count + 1));
	if (dir_buffer == NULL) {
		printf("no memory could be allocated\n");
		return_value = -ENOMEM;
	}
	/* copy the directory path to a temporary buffer */
	strncpy(dir_buffer, directory, path_count);

	/* check if the given input file directory exists. */
	if (stat(dir_buffer, &dir_stat)) {
		printf("File Error: Output file path does not exist\n");
		return_value = -ENOENT;
		goto out;
	}
	if (!S_ISDIR(dir_stat.st_mode)) {
		return_value = -ENOENT;
		printf("File Error: Output file directory does not exist\n");
		goto out;
	}

	/* check if the directory has write permissions */
	if (access(dir_buffer, W_OK)) {
		printf("File Error: Input file dir has no write permissions\n");
		return_value = -EPERM;
		goto out;
	}

out:
	free(dir_buffer);
	return return_value;
}

/* check if the input file is valid */
int ifile_isvalid(char *file_path)
{
	struct stat file_stat;

	/* get the stats of the input file */
	if (stat(file_path, &file_stat)) {
		printf("File Error: Input file does not exist\n");
		return -ENOENT;
	}
	/* check if the file is a regular file */
	if (!S_ISREG(file_stat.st_mode)) {
		printf("File Error: Input file is not a regular file\n");
		return -EFAULT;
	}

	/* check if the file has read permissions */
	if (access(file_path, R_OK))
		return -EPERM;
	return 0;
}

/* check if the given output file is valid */
int ofile_isvalid(char *file_path)
{
	struct stat file_stat;

	/* check if the output file exists in current directory */
	if (!strchr(file_path, '/')) {
		/* check if file exists */
		if (stat(file_path, &file_stat) == -1) {
		/* if file does not exist,current dir can make a file? */
			if (access("./", W_OK)) {
				printf("Current dir has no write perms\n");
				return -EPERM;
			} else
				return 0;
		} else if (access(file_path, W_OK)) {
			printf("File Error: file dir has no write perms\n");
			return -EPERM;
		} else
			return 0;
	} else {
		/* if exists in another dir, check if dir & file are valid */
		return dir_isvalid(file_path);
	}
	return 0;
}

int main(int argc, char *argv[])
{
	Files *files;
	unsigned char md[SHA256_DIGEST_LENGTH];
	extern char *optarg;
	extern int optind;
	char *input_filename, *output_filename, *password, c_flag;
	int c_count = 0, d_count = 0, e_count = 0, p_count = 0;
	int rc, operation = 1, return_value = 0;
	char *help_text = "./xhw1 -[c|e|d] input output -p password\n";

	if (!(argc == 4 || argc == 6))
		goto out;

	while (optind < argc &&
	(c_flag = getopt(argc, argv, "c:d:e:p")) != -1) {
		switch (c_flag) {
		case 'c':
			c_count += 1;
			operation = 4;
			if (c_count > 1)
				goto out;
			input_filename = argv[optind - 1];
			output_filename = argv[optind];
			break;
		case 'd':
			d_count += 1;
			operation = 2;
			if (d_count > 1)
				goto out;
			input_filename = argv[optind - 1];
			output_filename = argv[optind];
			break;
		case 'e':
			e_count += 1;
			operation = 1;
			if (e_count > 2)
				goto out;
			input_filename = argv[optind - 1];
			output_filename = argv[optind];
			break;
		case 'p':
			p_count += 1;
			if (p_count > 1)
				goto out;
			password = argv[optind];
			break;

		default:
			goto out;
		}
	}
	if (((e_count == 1 || d_count == 1) && p_count == 0))
		goto password_error;
	if (c_count + e_count + d_count != 1)
		goto out;
	return_value = ifile_isvalid(input_filename);
	if (return_value < 0)
		goto error;
	return_value = ofile_isvalid(output_filename);
	if (return_value < 0)
		goto error;
	if (p_count == 1 && (strlen(password) < 6 || strlen(password) > 256))
		goto password_error;

	files = malloc(sizeof(Files));
	files->input = input_filename;
	files->output = output_filename;
	files->hash = md;
	files->EDC_flag = operation;

	if ((!(files->EDC_flag & 0x4) == 1) &&
	!simpleSHA256(password, strlen(password), md)) {
		printf("Hash Error: Could not generate SHA hash for the key\n");
		goto out;
	}
	rc = syscall(__NR_cpenc, (void *) files);
	if (rc == 0)
		printf("System call success: %d\n", rc);
	else
		printf("Error: %d (errno = %d - %s)\n", rc,
		errno, strerror(errno));

	free(files);
	exit(rc);

error:
	printf("System call error: -1 (errno = %d - %s)\n",
	return_value * -1, strerror(return_value * -1));
	exit(0);
out:
	printf("Input Error: input not according to the syntax\n");
	printf("============================\n");
	printf("type '.\tcpenc -h' for syntax\n");
	printf("============================\n");
	printf("%s\n", help_text);
	exit(0);

password_error:
	printf("Password Error: Password is mandatory to encrypt & decrypt\n");
	printf("Password Error: 6 < password length < 256 characters\n");
	return 0;
}
