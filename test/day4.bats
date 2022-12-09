setup() {
  source "./src/day4.bash"
}

@test "day4 parse input" {
  run parse_input < <(cat <<EOF
2-4,6-81
2-3,4-5
EOF
)
  [ "$status" -eq 0 ]
  expected='[[2,4],[6,81]]
[[2,3],[4,5]]'
  [ "${output}" = "${expected}" ]
}

@test "day4 puzzle 1" {
  run part1 < './test/inputs/day4.txt'
  [ "$status" -eq 0 ]
  [ "$output" -eq 2 ]
}

@test "day4 puzzle 2" {
  run part2 < './test/inputs/day4.txt'
  [ "$status" -eq 0 ]
  [ "$output" -eq 4 ]
}
