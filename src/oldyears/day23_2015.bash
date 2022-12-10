#!/bin/bash

set -euo pipefail

#hlf r sets register r to half its current value, then continues with the next instruction.
#tpl r sets register r to triple its current value, then continues with the next instruction.
#inc r increments register r, adding 1 to it, then continues with the next instruction.
#jmp offset is a jump; it continues with the instruction offset away relative to itself.
#jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
#jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).

parse_input() {
  jq -sRc -f <(cat <<EOF
def readoffset: .dir as \$dir | .offset | tonumber | if \$dir == "-" then . * -1 else . end;
split("\n")
| map(
  limit(1;
    (capture("^hlf (?<r>.)\$") | { kind: "hlf", reg: .r })
    , (capture("^tpl (?<r>.)\$") | { kind: "tpl", reg: .r })
    , (capture("^inc (?<r>.)\$") | { kind: "inc", reg: .r })
    , (capture("^jmp (?<dir>[+-])(?<offset>[0-9]+)\$")
      | { kind: "jmp", offset: readoffset })
    , (capture("^jie (?<r>.), (?<dir>[+-])(?<offset>[0-9]+)\$")
      | { kind: "jie", reg: .r, offset: readoffset })
    , (capture("^jio (?<r>.), (?<dir>[+-])(?<offset>[0-9]+)\$")
      | { kind: "jio", reg: .r, offset: readoffset })
  )
)
EOF
)
}

evaluate() {
  jq -c \
    --argjson inita "$1" \
    -f <(cat <<EOF
. as \$instrs
| { a: \$inita, b: 0, i: 0 }
| until(
  .i < 0 or .i >= (\$instrs | length);
  \$instrs[.i] as \$instr
  | if \$instr.kind == "hlf" then
    .[\$instr.reg] /= 2 | .i += 1
  elif \$instr.kind == "tpl" then
    .[\$instr.reg] *= 3 | .i += 1
  elif \$instr.kind == "inc" then
    .[\$instr.reg] += 1 | .i += 1
  elif \$instr.kind == "jmp" then
    .i += \$instr.offset
  elif \$instr.kind == "jie" then
    if .[\$instr.reg] % 2 == 0 then
      .i += \$instr.offset
    else
      .i += 1
    end
  elif \$instr.kind == "jio" then
    if .[\$instr.reg] == 1 then
      .i += \$instr.offset
    else
      .i += 1
    end
  else
    .
  end
)
| .b
EOF
)
}

part1() {
  parse_input | evaluate 0
}

part2() {
  parse_input | evaluate 1
}
