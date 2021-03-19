! Copyright (C) 2021 Lewis Weinberger.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel sequences sets hash-sets math aoc formatting ;
IN: 1

:: look-up? ( elt hash-set -- ? )
  2020 elt - hash-set in? ;

:: 2look-up? ( elt seq hash-set -- ? ) 
  seq [ 2020 swap - elt - hash-set in? ] any? ;
  
: part-one ( seq hash-set -- n )
  [ look-up? ] curry filter product ;

: part-two ( seq hash-set -- n ) 
  dupd [ 2look-up? ] 2curry filter product ;

: main ( -- )
  ! read puzzle input into hash set for fast look-up
  input>sequence dup >hash-set [ part-one ] [ part-two ] 2bi
  "A) %d\nB) %d\n" printf ;

MAIN: main
