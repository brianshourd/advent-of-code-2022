#!/bin/bash

set -euo pipefail

impl() {
  jq -sRc --argjson points "$1" 'split("\n") | map($points[.] // 0) | add'
}

part1() {
  impl '{"A X": 4, "A Y": 8, "A Z": 3, "B X": 1, "B Y": 5, "B Z": 9, "C X": 7, "C Y": 2, "C Z": 6}'
}

part2() {
  impl '{"A X": 3, "A Y": 4, "A Z": 8, "B X": 1, "B Y": 5, "B Z": 9, "C X": 2, "C Y": 6, "C Z": 7}'
}

# What follows is an older (probably better) solution using pure bash instead of
# abusing jq
calculate_total() {
  declare -n points_ref=$1
  declare -i total=0
  while IFS= read -r line; do
    total=total+"${points_ref[${line}]}"
  done

  echo "${total}"
}

part1_bash() {
  declare -A points=(
    [A X]=4
    [A Y]=8
    [A Z]=3
    [B X]=1
    [B Y]=5
    [B Z]=9
    [C X]=7
    [C Y]=2
    [C Z]=6
  )
  calculate_total points
}

part2_bash() {
  # X means you must lose
  # Y means you must end in a draw
  # Z means you must win
  declare -A points=(
    [A X]=3 #0+3
    [A Y]=4 #3+1
    [A Z]=8 #6+2
    [B X]=1 #0+1
    [B Y]=5 #3+2
    [B Z]=9 #6+3
    [C X]=2 #0+2
    [C Y]=6 #3+3
    [C Z]=7 #6+1
  )
  calculate_total points
}
