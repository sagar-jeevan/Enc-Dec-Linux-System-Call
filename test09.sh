#!/bin/bash
# Shell script to test the system call for different input sizes!

# *******************************************************************
# This script is for parsing different arguments in a different way!!
echo "This script is for parsing different arguments in different way"
echo "**************************************************************"

# *******************************************************************
rm -rf test09_input
touch test09_input

for i in {1..99};
do 
	echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test09_input; 
done

./xhw1 -p "test_password" -c test09_input test09_output > test09_arg1
if cmp test09_input test09_output; 
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test09_output
# *******************************************************************

./xhw1 -c test09_input test09_output -p "test_password" > test09_arg1
if cmp test09_input test09_output;
then
	echo "----------------------------------> TEST CASE 1 PASSED"
else
	echo "----------------------------------> TEST CASE 1 FAILED"
fi
rm -rf test09_output

# *******************************************************************

./xhw1 -e test09_input test09_enc -p "test_password" > test09_arg1
./xhw1 -p "test_password" -d test09_enc test09_output > test09_arg1

if cmp test09_input test09_output;
then
	echo "----------------------------------> TEST CASE 2 PASSED"
else
	echo "----------------------------------> TEST CASE 2 FAILED"
fi
rm -rf test09_output


# *******************************************************************

./xhw1 -c test09_input test09_output > test09_arg1

if cmp test09_input test09_output; 
then
	echo "----------------------------------> TEST CASE 3 PASSED"
else
	echo "----------------------------------> TEST CASE 3 FAILED"
fi
rm -rf test09_output test09_arg1 test09_enc test09_input

# *******************************************************************
echo "**************************************************************"
