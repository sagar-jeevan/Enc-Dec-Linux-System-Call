#!bin/bash
# Test to check if the password length is atleast 6 characters

echo "**************************************************************"
echo "shell script to check if 6 < password length < 256 characters!"
echo "=============================================================="

rm -rf test07_input 
touch test07_input
./xhw1 -e test07_input test07_output -p "test" > test07_password

echo "Testing: MINIMUM PASSWORD LENGTH"

if grep --quiet "Password Error: 6 < password length < 256 characters" test07_password
then
    echo "----------------------------------> TEST CASE 0 PASSED"
else
    echo "----------------------------------> TEST CASE 0 FAILED"
fi

rm -rf test07_input test07_output test07_password
# *********************************************************************

rm -rf test07_input 
touch test07_input
./xhw1 -e test07_input test07_output -p "kwQdV13mJLvWOpQSvCo35qxtSg1zMLfVxHpMo5qdTKR3lqlNsCesVsXQWi2IEXCbAfvEiAgwSBqIgLUGbM81n6ZqNtMhKPfvnwsrIkoWpzRbGcihZ4KVuZQrGOCtD42B7etkdEvybamnckG8vjVXPuW6eAZkV38qfAPeABeDFmmiUEMuVWj47wuSoOeYCFTCu4k4ZLQfx5VJZupnuP4kMaAEWREtS3l4IKGAQxWwcIqGgJBDoyRbMx55OoSBTU822" > test07_password

echo "Testing: MAXIMUM PASSWORD LENGTH"

if grep --quiet "Password Error: 6 < password length < 256 characters" test07_password
then
    echo "----------------------------------> TEST CASE 0 PASSED"
else
    echo "----------------------------------> TEST CASE 0 FAILED"
fi

rm -rf test07_input test07_output test07_password
echo "**************************************************************"

# *********************************************************************
