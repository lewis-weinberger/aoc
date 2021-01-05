from strutils import parseInt
import tables, strformat

when isMainModule:
  var line: string
  var expenses: seq[int]
  var tab = initTable[int, string]()

  # Read input from stdin
  while stdin.readLine(line):
    expenses.add(parseInt(line))
    tab[expenses[^1]] = line

  # Part A
  for e in expenses:
    let x = 2020 - e
    if tab.hasKey(x):
      echo(&"A) {e} * {x} = {e*x}")
      break

  # Part B
  block pairwise:
    for e1 in expenses:
      for e2 in expenses:
        let x = 2020 - e1 - e2
        if tab.hasKey(x):
          echo(&"B) {e1} * {e2} * {x} = {e1*e2*x}")
          break pairwise
