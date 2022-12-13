setup() {
  source "./src/day13.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day13 parse_input" {
  input=$(cat <<EOF
[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]
EOF
)
  run parse_input <<< "$input"
  [ "$status" -eq 0 ]
  expected='[[[1,1,3,1,1],[1,1,5,1,1]],[[[1],[2,3,4]],[[1],4]]]'
  assert_equiv_json "$output" "$expected"
}

@test "day13 part1" {
  run part1 < ./test/inputs/day13.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 13 ]
}

@test "day13 part2" {
  run part2 < ./test/inputs/day13.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 140 ]
}
