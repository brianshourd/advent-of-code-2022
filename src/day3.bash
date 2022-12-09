#!/bin/bash

set -euo pipefail

declare -g priorities
priorities=$(jq -cn '
  "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  | split("")
  | with_entries({key: .value, value: .key})
')

part1() {
  jq -scRr \
    --argjson priorities "${priorities}" \
    -f <(cat <<EOF
split("\n")
| map(
  select(. != "")
  | split("")
  | [.[:length / 2], .[length / 2:]]
  | map(unique)
  | flatten
  | group_by(.)
  | map(select(length > 1) | .[0])[0]
  | \$priorities[.]
)
| add
EOF
)
}

part2() {
  jq -scRr \
    --argjson priorities "${priorities}" \
    -f <(cat <<EOF
split("\n")
| map(select(. != ""))
| (
  . as \$orig
  | [range(\$orig | length / 3)]
  | map(\$orig[(.*3):(.*3+3)])
)
| map(
  map(split("") | unique)
  | flatten
  | group_by(.)
  | map(select(length > 2) | .[0])[0]
  | \$priorities[.]
)
| add
EOF
)
}

# An older solution that is much slower because it spawns a bunch of processes.
# On the other hand, it uses more bashisms, which is why I kept it here.
parse_input() {
  jq -scR '
    split("\n") |
    map(
      select(. != "") |
      split("") |
      [
        .[:length / 2],
        .[length / 2:]
      ]
    )
  '
}

# Input: single array with two items, each item an array of strings
find_overlaps() {
  jq -cr '
    map(unique) |
    flatten |
    group_by(.) |
    map(select(length > 1) | .[0])[0]
  '
}

# Input: single character
to_priority() {
  declare lookup="_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  declare prefix=${lookup%%$1*}
  echo ${#prefix}
}

part1_bash() {
  declare -i total=0
  declare -i priority=0
  while IFS= read -r line; do
    priority=$(to_priority $(find_overlaps <<<"${line}"))
    total=$((total+"${priority}"))
  done < <(parse_input | jq -c '.[]')
  echo "$total"
}

