#!/bin/bash
# Shell script to test system call for different block sizes !
# *********************************************************************

echo "**************************************************************"
echo "Shell script to test the system call for different block sizes"
echo "DEFAULT BUFFER BLOCK SIZE IS 4K"
echo "=============================================================="

# *******************************************************************

echo "INPUT SIZE LESS THAN 4K"
rm -rf test01_input test01_output test01_enc
touch test01_input

echo "test_input test_output" >> test01_input;

./xhw1 -e test01_input test01_enc -p "test_password" > test01_arg1
./xhw1 -d test01_enc test01_output -p "test_password" > test01_arg1

if cmp test01_input test01_output;
then
	echo "----------------------------------> TEST CASE 0 PASSED"
else
	echo "----------------------------------> TEST CASE 0 FAILED"
fi
rm -rf test01_input test01_output test01_arg1 test01_enc

# *******************************************************************

echo "INPUT SIZE EQUAL TO 4K"
rm -rf test01_input test01_output test01_enc
touch test01_input

echo "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" >> test01_input;

./xhw1 -e test01_input test01_enc -p "test_password" > test01_arg1
./xhw1 -d test01_enc test01_output -p "test_password" > test01_arg1

if cmp test01_input test01_output;
then
	echo "----------------------------------> TEST CASE 1 PASSED"
else
	echo "----------------------------------> TEST CASE 1 FAILED"
fi
rm -rf test01_input test01_output test01_arg1

# *******************************************************************

# *******************************************************************

echo "INPUT SIZE GREATER THAN 4K"
rm -rf test01_input test01_output test01_enc
touch test01_input

echo "riB7F9ZuOvSq9MMBlOn2HBmzhLZelUenttcqZf1sXjscSjn2XjpZTFGKCBq5l9fW8kZ1pfyHa1fTPa3y6BqA5QQUm1tF2fE639zjl3xCpeFd6gnq3JLyc4trTx4TOUF6mZnxtlmvVGyqqDekctoiQLO1MuRETElO0XgnZ1l7dY6vI3LtEwjqJ758U7OzCYt7CJjKnLKrTPfvAxXHXk1ZnqkKUVKB218i3L4eY87au9Ysh3oPhxeFqHDrYtmhY8jaezamrQpSB6D0Oy8VMYXnHgRm8T6vM8HJUkjbPI9FFHAwQgNA8ZCowvCTsCaX3bfkzTNZT8E8lBOjQU1izeKxEc1n5L5uwtTcPQNv3oTjCEl5T9aWvoYIYGNel65e6hLQN8S12C1A89g9C2IMLerBx0JzjaZfkfBUFePUGEnUFKBbFWe2O9DSd3dFpTBt5vSVYVIG6c04Qw1UblurTzJVWXWIvPjt8A4JakwTGYxUzssVRb7ah4rRkjIkpe0KTJyjoYDa7qvUToBPxJLPdixzLfA6RymguSzBjfSfUIfdflTQYDhc5nzl92kpguXvzCve1oplXtJ8tM0Y8O8M86OLTXD7Vlam7hEW0iQesbLFsrc9z7zdZsNKwiXamtcrDd7GTEVYknvk7AltuaWTjVOlb0gLHsQXh8EjJ2QRHE9IQmvf8MqIZ0A5P4DDHGGlro1OxjtTZB52GmaQNaHLvsdh9X7QJbOczoOT5UqG1CWWjGEb9MGixKHNsQbdYLGul8bSl03KtVXAE66lRKhKmhMpCTWY7z3cKqQVuGFXNXLmaN8r8iumCid0mNEONU9WtOGPFeYXA36RxTzN5pRGAsnHfkDLDsLLXcrRbRsqzHwPHIO2yNXbQIdmEEj0XtMupJiZ989sCmWZuwUWHUup3EmT6h2QfwAHgKh6w774vl1bOQ7moYARuw8i8Y55VL5uRiX1VNqoHPICEJX2pXuAIiIzayf8fdTUfLrfhWNmd8XWPvYHxo0omsrI0BHJh1CzIljJdzDujjyhWjtlJCNmp1iTxc6wONFb1PhheEWOeZZHGBrvHOCZsHDpviNIeXZMcg6ZZzutCurIOzY3XU6uioS6hztPfwYWb1wWxH6NNYCXirmLdjmzREIvRFeeX409TdBjvFKwxRJp1GLxsRh4xIM1iudM1mLEWAHpFl8ydeRwZVVqgLZOIgbUoNq1XufnblNmZYe4xTYKcJ4x9HEkzqW9J1ooaDzZIXDEqlahPt7djtk3DjPpmI96DSxeccyca6nj0xmFb0hs2xWYJOZgqevaXW2RlBwvw6P8higepqzNAoNtaczCoIArDfvge8w0hJF0bgV05zhYMaMIoY1miMt1C6jvjN2BWVqElq7y7tkK6ZhLHjWi68lVhjgZPNiyA6eUXAlCojBbc0RGsuhCPgMEJ3xRhtRi8C9Fjew8xcLLQTgf3G5Zlg32puyfiehZGEPz15SQBwr9sTjwoJl29BKpcTnNFSr1BW0faUCreMHqArSbTKxgXaNNbcDoDlJwCP9DtrkJywDDSDFSFSDFSDFSDFSDFSDFSDFSDFSDFDSFcwT477vGVHnSJm2XZS9FRXUEsHqxJeGDmhKVdb2LH7TvUCOFpK8OpVSGpGExa6XFtxbOtH65Sm0Qhk1axyufd5MjLdxDhRlf1MK6PUkDrGhTYx6jYb168FUyRyfPxAovjMdHJtyfYiXlm96eZx1wjEmGQmMWDSe9nUHXJD907jzO6WFGKPPeBq2su5gGnyrYF4ZhVvnuRtyucv74lVn3vC2M2yhcczKBAvc3HjgIUyAujn6zpZzSLL2xEzG1KEdNLHEd6XBwENN6Xdf5LPlriseZ9iPw2APDld7CJygu0uPJ6LoTzf0VH61Q06OYV5APfC1geuf8VNzrtiiyR25RNhxT6Hbjcy0Mm6bMueRaIjv5DBOWyN0B6tUWNJ8bkLuopAtiKj6Yq0WcF5Ey1I8oxy4egofombCukoRCf5lDYrBwQD2cSExBkkYSvSO1M1gUr9pFMVxUwvyuGZnGBjwx2yrYGoTf5OGYP1ov408sClDeBi2oSxrvDp1sNTWVBvt0xYu4eAVduD31X1pJ7UMdzf0Myc5Qwh3a30dMnQVvKMESU2BdK6nnoYbSHPNF9UlyqUQDIKY99xrydQ1JLrTAMCU3EcmzOoSpFgsTEVVhF9aaYetTSm9KFLrjqZXraoJEcvTUIVgNcNduHZseiH5959S4eqmqSh6bBM9Pmsmlp5TWWL8pIkqbKy8bIfxoUhbo4GQmsMAlhGLVCAqDuDIkxK3uSBe4nfdTINoIdt6xy3mpDN1CTXM36mPZmVikIIVfqNOMe9qM4rJJ9pg2pu8nqjafGIoetSaj8HjpGHJ8QGiNErfmGqnNWxQFnaIaSEci6ufWICEhkimB8TSkUtYVrcoLaWBp4HhHpLZKbqO63V1x0ye4vPcPeyVGDOEoVbN2atYJqqDfr3CRSiquj2ejbpdq2EbLnjUhujTtltCwLr7dOtbGr2JDRlJHTzIlUch7lth1Ym2PvIdI3MUgHTzN7cduRWx2rZC8gesHYJiwi9PfJMfsc5CCIrEwkiPAbwfTs8po8mU0xtFMi6i3m7W45eORoDGeGIqn8fK6Ye0JbqV3MEO24P8ZOu98mFZWhCks1LWT70tNBWCAcZi5EkdSKRMie8751F6eggPq15I4Ml4aZagfRVJk8Z5Jh5it5q2pTrwSClIXaKDHCXh8TeaJpxpPJLtwMV2kRNY9WQUcjri61jDPAKBY9yfcIQYIOq2oYYgf7PJQCKAuVLnduQiObJT95XopwkagWjrZnn7TTQk1PLvhWvZFS6arql2kKmaeM7NN7Lq0BDXAD1uSIU7hjD8YiGdCIdU9buyUdy4rxOQnQ9F7QmRBEq41DLkXq786EFJw0a2pWErw5hor9LZQSt81ToOWSWeD8jOM9iNu97jtOvkyrPmCc2msgZKe1jf9kacVJYmdLmO5qXQlBNciuclKgUwWBT5NSlGeu56xICGfO9vdJjwmGXeB5PWOb9YBvdMBWxqRYSJabN43vAy2DDwwM2fFzrn6PDAdkZaGCx3clHPVrIW5sB81CG9J0XObpXZLduJ4SPpZbosOnGQlcxrxXJ3ETM7HfKUqJnRmXTKYyb0hnKpJIdskV15MolmJTAA95TZ9DtfHbZw4i3KUfRWNi1GgH68KPyqV7blRaM988Fkc9EvMncSk53CsCFbqVHd8uaNhblOhRxvhHpUdozjBHVveUOYPJP41JOV5qze5wooBVIUm8rd79HssbyUquLyCJntDlxRmuAJyEkM3rd2cz4LahOSRdegwD8webFzAnegIIfXr6yDHZ05gCGegIXeURY9GaoJjMoUGenHOXDppkSqHUWBcsdCGLYopCbS9EWbrEcmnFxfkfrhp8ZvDyy0tOLhYXi8LNpLC8x3utei2EriiSzZRmrsWSZNHtXxNnv0eUc7YU0cIv0lhAYG5XxGlQOD4RG8qPobYEfgzgWgq9cXrzyt1DBsrVdbMzZhVpO5feNViwkJnjrVxUlru6fb4si5RPSwfZmvX4e6HcOoibGjoe80DWMJmYMQOujFGQ4TT2OCwiVPZmy6fVKBJqkHNIcBkdXlxpeG0AVsocvUZq1n0XBkNy3NzqFY9mIx2y1koLHaYgoug8rj2cp29uUndPvOFhgsstyX7WuUDqI2q5Gy9pnqpP44OJkwXOHO9OAPFbtAucNRB9cRjmVLzrKp0oMKWP9IIpX2msJh8WusTDB7cna2tvsId7a9iAgp2Sw6B6fJ02wZoZmtAOmsrWi06skOCr2mCqM3XG4I9APBKGRN1nlQ8IkniLVKvuTe57mCHDxihIwOv8q4jz3j0Klpc9gDrk7rcxeCss1h5DqEk8XL5E2v8KRYHZjXhVFOTpehha6SXXkHmEDfrfBru5zHzB1qKxDyi0ZC7G5hmfg5EQuzwfJGJ6XiE3Z1KLIN7HaZOfFlI3FTfC6f0MFhT16rUTNzgQ575dxxhw0Gmh69XZGLRsHNSHh3TAuzpd6PyIv3C5lZB0aYIKpq6y0PXT0hi7DZhEsXhpq1PSQRgV3Kg0ElmbfX6gANTe2p1fGRU9s7ZH9VoacHKNZ" >> test01_input;

./xhw1 -e test01_input test01_enc -p "test_password" > test01_arg1
./xhw1 -d test01_enc test01_output -p "test_password" > test01_arg1

if cmp test01_input test01_output;
then
	echo "----------------------------------> TEST CASE 2 PASSED"
else
	echo "----------------------------------> TEST CASE 2 FAILED"
fi
rm -rf test01_input test01_output test01_arg1 test01_enc

# *******************************************************************
