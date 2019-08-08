#!/bin/bash
# Shell script to test encyption system call for different input sizes!

# *********************************************************************
# Test for copying files with size zero! 

echo "**************************************************************"
echo "shell script to test enc/dec of files for different input size"
echo "=============================================================="

rm -rf test05_input test05_encrypted
touch test05_input
./xhw1 -e test05_input test05_encrypted -p "test_password" > test05e_zero
./xhw1 -d test05_encrypted test05_output -p "test_password" > test05_zero

echo "Testing: Encryption with Empty file test"

if cmp test05_input test05_output; 
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test05_input test05_encrypted test05_output

# *******************************************************************
# Test for copying files with small size! 

rm -rf test05_input test05_encrypted
touch test05_input

for i in {1..99}; 
do 
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test05_input; 
done

./xhw1 -e test05_input test05_encrypted -p "test_password" > test05e_small
./xhw1 -d test05_encrypted test05_output -p "test_password" > test05_small

echo "Testing: Encryption with Small file size test"
if cmp test05_input test05_output; 
then
	echo "----------------------------------> TEST CASE 1 PASSED"
else
	echo "----------------------------------> TEST CASE 1 FAILED"
fi
rm -rf test05_input test05_encrypted test05_output

# *******************************************************************
# Test for copying files with medium size! 

rm -rf test05_input test05_encrypted
touch test05_input

for i in {1..9999}; 
do
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test05_input; 
done

./xhw1 -e test05_input test05_encrypted -p "test_password" > test05e_medium
./xhw1 -d test05_encrypted test05_output -p "test_password" > test05_medium

echo "Testing: Encryption with Medium file size test"
if cmp test05_input test05_output; 
then
	echo "----------------------------------> TEST CASE 2 PASSED"
else
	echo "----------------------------------> TEST CASE 2 FAILED"
fi
rm -rf test05_input test05_encrypted test05_output

# *******************************************************************
# Test for copying files with large size!

rm -rf test05_input test05_encrypted
touch test05_input

echo "Testing: Encryption with Large file size test"
for i in {1..99999}; 
do
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test05_input; done

	./xhw1 -e test05_input test05_encrypted -p "test_password" > test05e_large
	./xhw1 -d test05_encrypted test05_output -p "test_password" > test05_large

if cmp test05_input test05_output; 
then
	echo "----------------------------------> TEST CASE 3 PASSED"
else
	echo "----------------------------------> TEST CASE 3 FAILED"
fi

rm -rf test05e_large test05_encrypted test05_large test05_args1 test05_input test05_output test05_zero test05_small test05_medium test05e_zero test05e_small test05_enc test05e_medium test05_arg1
echo "**************************************************************"

# *******************************************************************

