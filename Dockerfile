FROM alpine:3.17.0

RUN apk update
# Versions included just for information, I doubt any of these versions are very
# particular for running the code
RUN \
  apk add --no-cache \
  bash=5.2.12-r0 \
  curl=7.86.0-r1 \
  jq=1.6-r2 \
  entr=5.2-r0 \
  bats=1.8.2-r0 \
  ncurses=6.3_p20221119-r0 # Includes tput, used by bats for pretty printing

WORKDIR /adventofcode

COPY run.bash run.bash
COPY test test
COPY src src

ENTRYPOINT ["./run.bash"]
