#!/bin/bash
# shell script to test copy of a file for different input sizes!
# *******************************************************************
# Test for copying files with size zero! 
echo "**************************************************************" 
echo "shell script to test copy of a file for different input sizes!"
echo "=============================================================="

rm -rf test03_input test03_output
touch test03_input
./xhw1 -c test03_input test03_output -p "test_password" > test03_zero

echo "COPY AN EMPTY FILE: SIZE ZERO"

if cmp test03_input test03_output; 
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test03_input test03_output

# *******************************************************************
# Test for copying files with small size! 

rm -rf test03_input test03_output
touch test03_input

for i in {1..99}; 
do 
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test03_input; 
done

./xhw1 -c test03_input test03_output -p "test_password" > test03_small

echo "COPY A SMALL SIZE FILE"
if cmp test03_input test03_output; 
then
	echo "----------------------------------> TEST CASE 1 PASSED"
else
	echo "----------------------------------> TEST CASE 1 FAILED"
fi
rm -rf test03_input test03_output

# *******************************************************************
# Test for copying files with medium size! 

rm -rf test03_input test03_output
touch test03_input

for i in {1..999}; 
do
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test03_input; 
done

./xhw1 -c test03_input test03_output -p "test_password" > test03_medium

echo "COPY A MEDIUM SIZE FILE"
if cmp test03_input test03_output; 
then
	echo "----------------------------------> TEST CASE 2 PASSED"
else
	echo "----------------------------------> TEST CASE 2 FAILED"
fi
rm -rf test03_input test03_output

# *******************************************************************
# Test for copying files with large size!

rm -rf test03_input test03_output
touch test03_input

for i in {1..99999}; 
do
    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test03_input; done

./xhw1 -c test03_input test03_output -p "password" > test03_large

echo "COPY A LARGE SIZE FILE"
if cmp test03_input test03_output; 
then
	echo "----------------------------------> TEST CASE 3 PASSED"
else
	echo "----------------------------------> TEST CASE 3 FAILED"
fi
rm -rf test03_input test03_output test03_small test03_medium test03_large test03_zero
echo "**************************************************************"
# *******************************************************************

