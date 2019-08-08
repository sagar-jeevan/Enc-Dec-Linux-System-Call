#include <stdbool.h>

typedef struct{
        char *input, *output;
	unsigned char *hash;

	/* default key and block size */
	int key_length, ED_unit;
	
	/* if true, encrypt the file, else decrypt */
	int EDC_flag; 
}Files;	
