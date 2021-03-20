! Copyright (C) 2021 Lewis Weinberger.
! See http://factorcode.org/license.txt for BSD license.

USING: tools.test 2 ;
IN: 2.tests

[ t ] [ "1-3 a: abcde" parse valid? ] unit-test
[ f ] [ "1-3 b: cdefg" parse valid? ] unit-test
[ t ] [ "2-9 c: ccccccccc" parse valid? ] unit-test
[ t ] [ "1-3 a: abcde" parse valid?' ] unit-test
[ f ] [ "1-3 b: cdefg" parse valid?' ] unit-test
[ f ] [ "2-9 c: ccccccccc" parse valid?' ] unit-test
