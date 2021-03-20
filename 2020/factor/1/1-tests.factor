! Copyright (C) 2021 Lewis Weinberger.
! See http://factorcode.org/license.txt for BSD license.

USING: tools.test kernel hash-sets 1 ;
IN: 1.tests

{ 514579 } [ 
  { 1721 979 366 299 675 1456 } dup >hash-set part-one 
] unit-test

{ 241861950 } [
  { 1721 979 366 299 675 1456 } dup >hash-set part-two 
] unit-test
