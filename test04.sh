#!/bin/bash
# Shell script to test system call by wrong input parameters!
# *********************************************************************

echo "**************************************************************"
echo "Shell script to test system call by wrong enc/dec parameters!!"
echo "=============================================================="

# *******************************************************************
rm -rf test04_input
touch test04_input

echo "ENCRYPTION AND DECRYPTION OF AN EMPTY FILE"

./xhw1 -p "testing sys call" -e test04_input test04_enc > test04_arg1
./xhw1 -p "testing sys call" -d test04_enc test04_output > test04_arg1

if cmp test04_input test04_output; 
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test08_args1 test04_input test04_output

# *******************************************************************
echo "ENCRYPTION OF A NON EXISTING FILE"

./xhw1 -p "testing sys call" -e test04_input test04_enc > test04_arg1
if grep --quiet "File Error: Input file does not exist" test04_arg1;
then
	echo "----------------------------------> TEST CASE 1 PASSED"
else
	echo "----------------------------------> TEST CASE 1 FAILED"
fi
rm -rf test08_args1 test04_input test04_output

# *******************************************************************

echo "DECRYPTION OF A NON EXISTING FILE"

./xhw1 -p "testing sys call" -d test04_input test04_enc > test04_arg1
if grep --quiet "File Error: Input file does not exist" test04_arg1;
then
	echo "----------------------------------> TEST CASE 2 PASSED"
else
	echo "----------------------------------> TEST CASE 2 FAILED"
fi
rm -rf test08_args1 test04_input test04_output test04_zero test04_small test04_medium test04e_zero test04e_small test04_enc test04e_medium test04_arg1
# *******************************************************************
echo "**************************************************************"
