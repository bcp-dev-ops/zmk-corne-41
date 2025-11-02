#!/usr/bin/env bash
set -e

BOARD=nice_nano
SHIELD_LEFT=corne_left
SHIELD_RIGHT=corne_right
ZMK_DIR=../zmk

if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Starting Docker..."
    open -a Docker
    echo "Waiting for Docker to start..."
    while ! docker info > /dev/null 2>&1; do
        sleep 1
    done
    echo "Docker is now running."
fi

docker run --rm -it \
  -v "$(pwd)":/workdir/zmk-config \
  -v "$(pwd)/${ZMK_DIR}":/workdir/zmk \
  -w /workdir/zmk-config \
  zmkfirmware/zmk-dev-x86_64:4.1-branch \
  west build -s /workdir/zmk/app -d build/left -b $BOARD -- \
    -DSHIELD=$SHIELD_LEFT \
    -DZMK_CONFIG=/workdir/zmk-config/config

docker run --rm -it \
  -v "$(pwd)":/workdir/zmk-config \
  -v "$(pwd)/${ZMK_DIR}":/workdir/zmk \
  -w /workdir/zmk-config \
  zmkfirmware/zmk-dev-x86_64:4.1-branch \
  west build -s /workdir/zmk/app -d build/right -b $BOARD -- \
    -DSHIELD=$SHIELD_RIGHT \
    -DZMK_CONFIG=/workdir/zmk-config/config
