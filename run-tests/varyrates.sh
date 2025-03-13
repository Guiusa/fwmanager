#!/bin/bash

TEST="ping"
DIR=""
FLAG=0
while getopts "n:d:" option; do
  case $option in
    n)
      TEST=$OPTARG;;
    d)
      DIR=$OPTARG
      FLAG=1;;
  esac
done

[[ $FLAG == 0 ]] && echo -e "BAD USAGE\nvaryrates.sh -d <OUT_DIR> [-n testname]" && exit 1

RATE=1000
RATE_MAX=100000000

[[ ! -d results/$DIR ]] && mkdir results/$DIR
while [ $RATE -le $RATE_MAX ]; do
  ./$TEST.sh -q -r $RATE -c 100000
  ./dumpts.py ping > results/$DIR/${TEST}_${RATE}r.out
  RATE=$((RATE*10))
done
