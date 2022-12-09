setup() {
  source "./src/day7.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

directory_size() {
  get_list_of_files | calculate_directory_size
}

@test "day7 directory size" {
  run directory_size < ./test/inputs/day7.txt
  [ "$status" -eq 0 ]
  expected='[{"d":["/"],"s":48381165},{"d":["/","a"],"s":94853},{"d":["/","a","e"],"s":584},{"d":["/","d"],"s":24933642}]'
  assert_equiv_json "$output" "$expected"
}

@test "day7 part 1" {
  run part1 < ./test/inputs/day7.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 95437 ]
}

@test "day7 part 2" {
  run part2 < ./test/inputs/day7.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 24933642 ]
}
