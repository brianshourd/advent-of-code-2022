setup() {
  source "./src/day12.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day12 parse_input" {
  run parse_input < ./test/inputs/day12.txt
  [ "$status" -eq 0 ]
  parsed="$output"
  run jq -c '{ "start": .start, "end": .end }' <<< "$parsed"
  [ "$status" -eq 0 ]
  expected='{"start": [0,0], "end": [5,2]}'
  assert_equiv_json "$output" "$expected"
}

@test "day12 part1" {
  run part1 < ./test/inputs/day12.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 31 ]
}

@test "day12 part2" {
  run part2 < ./test/inputs/day12.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 29 ]
}
