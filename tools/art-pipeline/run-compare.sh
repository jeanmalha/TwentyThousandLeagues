#!/bin/zsh
# Compare FLUX.1 schnell (4-bit, mflux) with Z-Image Turbo on the same prompts and seed.
cd "$(dirname "$0")" && source ./prompts.sh
M=dhairyashil/FLUX.1-schnell-mflux-4bit
run() { local name=$1 w=$2 h=$3 p=$4 t0=$(date +%s)
  mflux-generate --model $M --base-model schnell --low-ram --steps 4 --width $w --height $h \
    --seed 1868 --prompt "$p, $STYLE" --output out/$name-flux-1868.png > out/gen-flux-$name.log 2>&1
  echo "$name flux ${w}x${h}: $(( $(date +%s) - t0 ))s exit=$?"; }
run nemo2 576 768 "$NEMO2"
run salon 960 540 "$SALON"
