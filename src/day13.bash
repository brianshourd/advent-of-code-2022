#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc \
    -f <(cat <<EOF
split("\n\n")
| map(
  split("\n")
  | map(select(. != "") | fromjson)
)
EOF
)
}

declare -g compare_def
compare_def=$(cat <<EOF
def compare(\$right):
  def compare_number(\$r):
    if . < \$r then true elif . > \$r then false else null end;

  def compare_array(\$r):
    if length == 0 and (\$r | length > 0) then
      true
    elif length > 0 and (\$r | length == 0) then
      false
    elif length > 0 and (\$r | length > 0) then
      (.[0] | compare(\$r[0])) as \$v
      | if \$v == null then
        (.[1:] | compare_array(\$r[1:]))
      else
        \$v
      end
    else
      null
    end;

  if type == "number" and (\$right | type) == "number" then
    compare_number(\$right)
  elif type == "array" and (\$right | type) == "number" then
    compare_array([\$right])
  elif type == "number" and (\$right | type) == "array" then
    [.] | compare_array(\$right)
  elif type == "array" and (\$right | type) == "array" then
    compare_array(\$right)
  else
    null
  end;
EOF
)

part1() {
  parse_input | jq -c -f <(cat <<EOF
$compare_def
to_entries
| map(
  . as {key: \$i, value: [\$l, \$r]}
  | select(\$l | compare(\$r))
  | \$i + 1
)
| add
EOF
)
}

part2() {
  parse_input | jq -c -f <(cat <<EOF
$compare_def
def merge(\$b; \$acc):
  if length == 0 then
    \$acc + \$b
  elif (\$b | length) == 0 then
    \$acc + .
  elif (.[0] | compare(\$b[0])) then
    .[0] as \$x
    | .[1:]
    | merge(\$b; \$acc + [\$x])
  else
    merge(\$b[1:]; \$acc + [\$b[0]])
  end;
def sort_compare:
  if length <= 1 then
    .
  else
    (length / 2 | floor) as \$h
    | .[:\$h] as \$h1
    | .[\$h:] as \$h2
    | (\$h1 | sort_compare)
    | merge(\$h2 | sort_compare; [])
  end;
flatten(1) + [[[6]], [[2]]]
| sort_compare
| to_entries
| map(select(.value == [[6]] or .value == [[2]]) | .key + 1)
| .[0] * .[1]
EOF
)
}
