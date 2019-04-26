#!/bin/sh

mkdir -p out bin

# make base file
PROGRAMS=$(for f in $(find programs/ -type f); do
  echo -n "$(base64 -w0 "$f") ";
done)
BLOCK_COUNT=$(bc -l <<< "scale=4;n=l(4)/l(2)+0.0001;scale=0;n/1")
sed "s-{{PROGRAMS}}-$PROGRAMS-; s/{{BLOCK_COUNT}}/$BLOCK_COUNT/" body.sh > out/base

# Derive a binary value from last block.
D() {
  [[ $(tail -c128 "$1" | md5sum | cut -c1) =~ [0-7] ]]
  echo $?
}

# Generate a pair of colliding files from `out/base`.
G() {
  while ./fastcoll out/base -o out/body-$1-{0,1}.bin; do
    case $(D out/body-$1-0.bin)$(D out/body-$1-1.bin) in
    01) return ;;
    10) S out/body-$1-{0,1}.bin; return ;;
    esac
  done
}

# Swap two files.
S() {
  tmp=$(mktemp)
  mv "$1" "$tmp" &&
  mv "$2" "$1" &&
  mv "$tmp" "$2"
}

# align original file
cp out/base out/body &&
truncate out/body -s%64

# generate block pairs
for i in $(seq $BLOCK_COUNT); do
  G $i
  cp out/{body-$i-0.bin,base}
  tail -c128 out/body-$i-0.bin > out/block-$i-0.bin
  tail -c128 out/body-$i-1.bin > out/block-$i-1.bin
  rm out/body-$i-{0,1}.bin
done

# build executable files from generated blocks
for program_idx in $(seq 0 $(($(find programs/ -type f | wc -l) - 1)) ); do
  blocks=_$(printf "%${BLOCK_COUNT}d\n" $(bc <<<"obase=2;$program_idx") | tr \  0)
  cat out/body$(
    for block_idx in $(seq $BLOCK_COUNT); do
      echo -n " out/block-$block_idx-${blocks:$block_idx:1}.bin"
    done
  ) | install /dev/stdin bin/program-$program_idx
done

# vim:ts=2 sw=2 et
