setup() {
  source "./src/day11.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day11 parse_input" {
  input=$(cat <<EOF
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3
EOF
)
  run parse_input <<< "$input"
  [ "$status" -eq 0 ]
  expected='[{"items":[79,98],"operation":{"kind":"mult","factor":19},"test":{"divisor":23,"iftrue":2,"iffalse":3}}]'
  assert_equiv_json "$output" "$expected"
}

@test "day11 part1" {
  run part1 < ./test/inputs/day11.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 10605 ]
}

@test "day11 part2" {
  # Only a partial test, since the full thing takes 15 seconds
  run impl 2 20 < ./test/inputs/day11.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 10197 ]
}
