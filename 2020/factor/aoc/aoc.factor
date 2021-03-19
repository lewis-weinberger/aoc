! Copyright (C) 2021 Lewis Weinberger.
! See http://factorcode.org/license.txt for BSD license.

USING: io math.parser sequences ;
IN: aoc

: input>sequence ( -- seq )
  lines [ string>number ] map ;
