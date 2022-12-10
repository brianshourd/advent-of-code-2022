setup() {
  source "./src/day10.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day10 parse_input" {
  input=$(cat <<EOF
noop
addx 3
addx -5
EOF
)
  run parse_input <<< "$input"
  [ "$status" -eq 0 ]
  expected='[{"kind":"noop"},{"kind":"addx","n":3},{"kind":"addx","n":-5}]'
  assert_equiv_json "$output" "$expected"
}

@test "day10 part1" {
  run part1 < './test/inputs/day10.txt'
  [ "$status" -eq 0 ]
  [ "$output" -eq 13140 ]
}

@test "day10 part2" {
  run part2 < './test/inputs/day10.txt'
  [ "$status" -eq 0 ]
  expected=$(cat <<EOF
##  ##  ##  ##  ##  ##  ##  ##  ##  ##  
###   ###   ###   ###   ###   ###   ### 
####    ####    ####    ####    ####    
#####     #####     #####     #####     
######      ######      ######      ####
#######       #######       #######     
EOF
)
  [ "$output" = "$expected" ]
}
