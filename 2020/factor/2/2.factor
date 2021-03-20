! Copyright (C) 2021 Lewis Weinberger.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel combinators sequences splitting io formatting
math math.parser math.order ;
IN: 2

: parse ( str -- lo hi char str )
  "- " split first4
  { [ string>number ] [ string>number ] [ first ] [ ] } spread ;

:: valid? ( lo hi char str -- ? )
  str [ char = ] count lo hi between? ;

:: valid?' ( lo hi char str -- ? )
  { lo hi } [ 1 - ] map str nths first2 [ char = ] bi@ xor ;

: part-one ( seq -- n )
  [ parse valid? ] count ;

: part-two ( seq  -- n ) 
  [ parse valid?' ] count ;

: main ( -- )
  lines [ part-one ] [ part-two ] bi
  "A) %d\nB) %d\n" printf ;

MAIN: main
