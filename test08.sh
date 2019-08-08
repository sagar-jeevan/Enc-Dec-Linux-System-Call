#!/bin/bash
# Shell script to test system call by wrong input parameters!
# *********************************************************************

echo "**************************************************************"
echo "Shell script to test the system call by wrong input parameters"
echo "=============================================================="

rm -rf test08_input
touch test08_input

	./xhw1 -e test08_input test08_output -e -d -c -p "test_password"> test08_args1

if grep --quiet "Input Error: input not according to the syntax" test08_args1;
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test08_args1

# *******************************************************************

./xhw1 -p "test_password" -p test08_input test08_output -e test08_input test08_output > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;
then
	echo "----------------------------------> TEST CASE 1 PASSED"
else
	echo "----------------------------------> TEST CASE 1 FAILED"
fi
rm -rf test08_args2

# *******************************************************************

./xhw1 -p "test_password" -d test08_input test08_output -c test08_input test08_output > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;then
	echo "----------------------------------> TEST CASE 2 PASSED"
else
	echo "----------------------------------> TEST CASE 2 FAILED"
fi
rm -rf test08_args2

# *******************************************************************

./xhw1 -e test08_input test08_output -d test08_input test08_output -p "test_password" > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;
then
	echo "----------------------------------> TEST CASE 3 PASSED"
else
	echo "----------------------------------> TEST CASE 3 FAILED"
fi
rm -rf test08_args2

# *******************************************************************

./xhw1 -p "test_password" -e test08_input test08_output -d test08_input test08_output -c test08_input test08_output > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;
then
	echo "----------------------------------> TEST CASE 4 PASSED"
else
	echo "----------------------------------> TEST CASE 4 FAILED"
fi
rm -rf test08_args2

# *******************************************************************

./xhw1 -p "test_password" -d test08_input test08_output -d test08_input test08_output -d test08_input test08_output > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;
then
	echo "----------------------------------> TEST CASE 5 PASSED"
else
	echo "----------------------------------> TEST CASE 5 FAILED"
fi
rm -rf test08_args2

# *******************************************************************

./xhw1 -d -e -c -p -g -x > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;
then
	echo "----------------------------------> TEST CASE 6 PASSED"
else
	echo "----------------------------------> TEST CASE 6 FAILED"
fi
rm -rf test08_args2

# *******************************************************************

./xhw1 -e  test08_input -e test08_output -p > test08_args2
if grep --quiet "Input Error: input not according to the syntax" test08_args2;
then
	echo "----------------------------------> TEST CASE 7 PASSED"
else
	echo "----------------------------------> TEST CASE 7 FAILED"
fi
rm -rf test08_args2 test08_input

# *******************************************************************
echo "**************************************************************"
