setup() {
  source "./src/day3.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day3 parse input" {
  run parse_input < <(cat <<EOF
abcdefgh
xyZabc
EOF
)
  [ "$status" -eq 0 ]
  expected='[[["a","b","c","d"],["e","f","g","h"]],[["x","y","Z"],["a","b","c"]]]'
  assert_equiv_json "${output}" "${expected}"
}

@test "day3 find_overlaps" {
  run find_overlaps <<< '[["a", "b", "b", "c"], ["c", "X", "Y", "c"]]'
  [ "$status" -eq 0 ]
  [ "$output" = "c" ]
}

@test "day3 to_priority" {
  run to_priority "a"
  [ "$status" -eq 0 ]
  [ "$output" -eq 1 ]
  run to_priority "Z"
  [ "$status" -eq 0 ]
  [ "$output" -eq 52 ]
}

@test "day3 puzzle 1" {
  run part1 < './test/inputs/day3.txt'
  echo "$status"
  echo "$output"
  [ "$status" -eq 0 ]
  [ "$output" = 157 ]
}

@test "day3 puzzle 2" {
  run part2 < './test/inputs/day3.txt'
  [ "$status" -eq 0 ]
  [ "$output" = 70 ]
}
