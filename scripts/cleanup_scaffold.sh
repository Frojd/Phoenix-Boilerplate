#!/usr/bin/env bash

cd $(git rev-parse --show-toplevel)

rm -rf \
    src/web \
    src/test \
    src/priv \
    src/lib \
    src/deps \
    src/assets \
    src/config \
    src/_build

rm -f src/README.md src/mix.exs src/mix.lock

cd -
