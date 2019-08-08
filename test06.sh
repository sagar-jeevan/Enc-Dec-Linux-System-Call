#!/bin/bash
# Shell script to test if encrypted/decrypted file is different!!
# *********************************************************************

echo "**************************************************************"
echo "Shell script to test if encrypted/decrypted file is different!"
echo "=============================================================="
# *******************************************************************

echo "Testing: ENCYPTED FILE DIFFERENT FROM INPUT FILE"

rm -rf test06_input
for i in {1..1000}; 
do
	echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test06_input; 
done

./xhw1 -p "test_password" -e test06_input test06_output > test06_arg1

if cmp test06_input test06_output; 
then
    echo "======================================="
	echo "----------------------------------> TEST CASE 0 FAILED"
else
	echo "----------------------------------> TEST CASE 0 PASSED"
fi
rm -rf test06_input test06_output test06_arg1

# *******************************************************************

echo "Testing: DECRYPTED FILE DIFFERENT FROM INPUT FILE"

rm -rf test06_input
for i in {1..1000}; 
do
	echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test06_input; 
done
./xhw1 -p "test_password" -e test06_input test06_enc > test06_arg1
./xhw1 -p "test_password" -e test06_enc test06_output > test06_arg1

if cmp test06_enc test06_output; 
then
    echo "======================================="
	echo "----------------------------------> TEST CASE 1 FAILED"
else
	echo "----------------------------------> TEST CASE 1 PASSED"
fi
rm -rf test06_enc test06_input test06_output test06_arg1

echo "**************************************************************"
# *******************************************************************
