#!/bin/bash

set -euo pipefail

get_list_of_files() {
  jq -Rsc \
    -f <(cat <<EOF
split("\n")
| reduce .[] as \$line ({pwd: [], files: []};
  . as \$acc
  | \$line
  | limit(1;
    (
      capture("^[\$] cd (?<dir>[a-zA-Z./]+)\$")
        | . as \$cap
        | \$acc
        | if \$cap.dir == ".." then
            .pwd |= .[:-1]
          else
            .pwd += [\$cap.dir]
          end
    )
    , (
      capture("^(?<size>[0-9]+) (?<name>.*)\$")
        | . as \$cap
        | \$acc
        | .files |= . + [{path: \$acc.pwd, name: \$cap.name, size: \$cap.size | tonumber}]
    )
    , \$acc
  )
)
| .files
| unique
EOF
)
}

calculate_directory_size() {
  jq -c \
    -f <(cat <<EOF
map(
  .size as \$size
  | [
    foreach .path[] as \$i ([]; . + [\$i]; .)
    | {d: ., s: \$size}
  ]
)
| flatten
| group_by(.d)
| map({d: .[0].d, s: map(.s) | add})
EOF
)
}

part1() {
  get_list_of_files \
    | calculate_directory_size \
    | jq 'map(.s | select(. <= 100000)) | add'
}

part2() {
  get_list_of_files \
    | calculate_directory_size \
    | jq -f <(cat <<EOF
map(select(.d == ["/"]) | .s)[0] as \$used
| (30000000 - 70000000 + \$used) as \$required
| map(select(.s >= \$required) | .s)
| min
EOF
)
}

build_directory_structure() {
  get_list_of_files \
    | jq -f <(cat <<EOF
map(
  reduce (.path | reverse)[] as \$d({kind: "file", name, size};
    {(\$d): {
      kind: "directory",
      contents: [.]
    }}
  )
)
| reduce .[] as \$i({}; . * \$i)
EOF
)
}

calculate_sizes_from_walk() {
  build_directory_structure \
    | jq -f <(cat <<EOF
walk(
  if type == "object" then
    to_entries | map(.value) | add
  else
    .
  end
)
EOF
)
}
