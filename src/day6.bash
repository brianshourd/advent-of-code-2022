#!/bin/bash

set -euo pipefail

find_distinct_chunk() {
  declare -i size=$1
  jq -R \
    --argjson size $size \
    -f <(cat <<EOF
split("")
| try
  reduce .[\$size:][] as \$char (
    {
      buffer: .[:\$size],
      counts: .[:\$size]
        | group_by(.)
        | map({key: .[0], value: length})
        | from_entries,
      i: \$size
    };
    if (.counts | length) == \$size then
      error({kind: "break", value: .})
    else
      .counts[.buffer[.i % \$size]] |= if . == 1 then empty else . - 1 end
      | .counts[\$char] |= (. // 0) + 1
      | .buffer[.i % \$size] = \$char
      | .i += 1
    end
  )
catch if (.kind? // "") == "break" then .value else error end
| .i
EOF
)
}

part1() {
  find_distinct_chunk 4
}

part2() {
  find_distinct_chunk 14
}

# Below are some other, slower solutions, which use bash to do the heavy lifting
# instead of jq. They are preserved because they have some useful bashisms in
# them that I learned.
check_array_unique() {
  local IFS=$'\n'
  # Pass by reference
  declare -n buffer_ref=$1
  declare sorted
  sorted=$(sort <<<"${buffer_ref[*]}")
  declare uniqued
  uniqued=$(uniq <<<"$sorted")
  # We only need to check that they are the same length, which implies that they
  # are identical
  [ "${#sorted}" = "${#uniqued}" ]
}

find_distinct_chunk_orig() {
  declare -i size=$1
  declare -i i=0
  declare -a buffer=()
  while IFS='' read -r -d '' -n 1 char; do
    buffer[$(($i%$size))]=$char
    if [ $i -ge $(($size-1)) ]; then
      if check_array_unique buffer; then
        echo $(($i+1))
        exit 0
      fi
    fi
    i=$(($i+1))
  done
}

find_distinct_chunk_bash() {
  declare -i size=$1
  declare -a buffer=()
  declare -A counts=()
  declare count=
  declare old_char=
  declare -i i=0
  declare -i bi=0
  while IFS='' read -r -d '' -n 1 char; do
    if [ $i -ge $size ]; then
      # Check if we have all unique
      if [ "${#counts[@]}" -eq "$size" ]; then
        echo $(($i))
        exit 0
      fi

      # Update counts for removing old character
      old_char=${buffer[$bi]}
      count=${counts[$old_char]}
      if [ "$count" = 1 ]; then
        unset counts[$old_char]
      else
        counts[$old_char]=$(($count-1))
      fi
      # Update counts for adding new character
      counts[$char]=$((${counts[$char]-0}+1))
      # Update buffer of chars
      buffer[$bi]=$char
    else
      # Blinldy add
      buffer[$bi]=$char
      counts[$char]=$((${counts[$char]:-0}+1))
    fi
    i=$(($i+1))
    bi=$(($i%$size))
  done
}

