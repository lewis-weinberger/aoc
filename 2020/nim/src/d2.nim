from strscans import scanf 
from strutils import count
import strformat

when isMainModule:
  var 
    line: string
    na, nb = 0
    lo, hi: int
    c, str: string

  # Read input from stdin
  while stdin.readLine(line):
    if scanf(line, "$i-$i $w: $*", lo, hi, c, str):
      
      # Part A
      let n = count(str, c)
      if (lo <= n) and (n <= hi):
        inc na

      # Part B
      if (str[lo - 1] == c[0]) xor (str[hi - 1] == c[0]):
        inc nb

  echo(&"A) {na} valid passwords")
  echo(&"B) {nb} valid passwords")
