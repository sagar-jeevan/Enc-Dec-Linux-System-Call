#!bin/bash
# Test to check if the password length is atleast 6 characters

echo "**************************************************************"
echo "shell script to check input and output files with a path name!"
echo "=============================================================="

# *********************************************************************

rm -rf test10_input 
touch test10_input 
mkdir sample_test
echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." >> test10_input;

./xhw1 -e test10_input 'sample_test/test10_output' -p "test_password" > test10_arg1
./xhw1 -d 'sample_test/test10_output' test10_output -p "test_password" > test10_arg1

if cmp test10_input test10_output;
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test10_input sample_test/test10_output test10_arg1
rmdir sample_test
