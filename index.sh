#!/bin/bash

if [ ! -d ./sac ]; then
  exit -1
fi

cargo build --release --all-features
#cargo doc
#cargo run --example hello


