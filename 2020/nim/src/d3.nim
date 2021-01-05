from sequtils import foldl

const
  nWidth = 31
  dx = [1, 3, 5, 7, 1]
  dy = [1, 1, 1, 1, 2]

proc tree(str: string, x: var int, y: var int, dx: int, dy: int): int =
  let z = x
  if y mod dy == 0:
    x += dx
    if str[z mod nWidth] == '#':
      result = 1
  inc(y)

when isMainModule:
  var 
    line: string
    n, x, y = [0, 0, 0, 0, 0]

  # Read input from stdin
  while stdin.readLine(line):
    for i in 0 ..< len(n):
      n[i] += tree(line, x[i], y[i], dx[i], dy[i])

  echo("A) ", n[1], " trees encountered")
  echo("B) ", foldl(n, a * b))
