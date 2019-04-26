#!/bin/sh
PROGRAMS=( {{PROGRAMS}} )
BLOCK_COUNT={{BLOCK_COUNT}}
FILESIZE=$(stat -c%s "$0")
eval "$(base64 -d <<< ${PROGRAMS[$(( 2#$(for offset in $(seq $(($FILESIZE - 128 * $BLOCK_COUNT + 1)) 128 $(($FILESIZE - 127))); do
  [[ $(tail -c+$offset "$0"|head -c128|sha1sum|cut -c1) =~ [0-7] ]]
  printf $?
done) ))]})"
exit

