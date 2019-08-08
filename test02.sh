#!/bin/bash
# Shell script to test system call enc/dec for different password !
# *********************************************************************

echo "**************************************************************"
echo "Shell script to test system call enc/dec for different password"
echo "=============================================================="

# *******************************************************************
rm -rf test02_input test02_output test02_enc
touch test02_input

echo "test_input test_output" >> test02_input;

./xhw1 -e test02_input test02_enc -p "test_password1" > test02_arg1
./xhw1 -d test02_enc test02_output -p "test_password" > test02_arg2

if grep --quiet "Error: -1 (errno = 13 - Permission denied)" test02_arg2
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test02_input test02_output test02_arg1 test02_enc test02_arg2

# *******************************************************************

