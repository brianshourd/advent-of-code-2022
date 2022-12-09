#!/bin/bash

set -euo pipefail

parse_input() {
  sed -E 's/([0-9]+)-([0-9]+),([0-9]+)-([0-9]+)/\[\[\1,\2],\[\3,\4\]\]/g'
}

part1() {
  parse_input | jq -c '
    select(
      (.[0][0] <= .[1][0] and .[0][1] >= .[1][1]) or
      (.[0][0] >= .[1][0] and .[0][1] <= .[1][1])
    )
  ' | wc -l
}

part2() {
  parse_input | jq -c '
    select(
      (.[0][1] >= .[1][0] and .[0][0] <= .[1][1]) or
      (.[0][1] <= .[1][0] and .[0][0] >= .[1][1])
    )
  ' | wc -l
}
