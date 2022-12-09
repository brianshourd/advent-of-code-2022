#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc -f <(cat <<EOF
split("\n")
| {
  stacks: (
    map(
      select((startswith("move") | not) and (length > 0))
      | split("")
    )
    | transpose
    | map(
      reverse
      | select(.[0] | test("^[0-9]"))
      | map(select(. != " "))
      | .[1:]
    )
  ),
  instructions: (
    map(
      select(startswith("move"))
      | capture("move (?<move>[0-9]+) from (?<from>[0-9]+) to (?<to>[0-9]+)")
      | map_values(tonumber)
    )
  )
}
EOF
)
}

part1() {
  declare input
  input=$(parse_input)
  jq -cnr \
    --argjson input "$input" \
    -f <(cat <<EOF
reduce \$input.instructions[] as \$inst (
  # Add null to the beginning so that we aren't subtracting 1 from all indexes
  [null] + \$input.stacks;
  .[\$inst.to] = .[\$inst.to] + (.[\$inst.from][-\$inst.move:] | reverse)
  | .[\$inst.from] |= .[0:-\$inst.move]
)
| .[1:] # Now remove the null from the beginning
| map(.[-1])
| join("")
EOF
)
}

part2() {
  declare input
  input=$(parse_input)
  jq -cnr \
    --argjson input "$input" \
    -f <(cat <<EOF
reduce \$input.instructions[] as \$inst (
  # Add null to the beginning so that we aren't subtracting 1 from all indexes
  [null] + \$input.stacks;
  .[\$inst.to] = .[\$inst.to] + .[\$inst.from][-\$inst.move:]
  | .[\$inst.from] |= .[0:-\$inst.move]
)
| .[1:] # Now remove the null from the beginning
| map(.[-1])
| join("")
EOF
)
}
