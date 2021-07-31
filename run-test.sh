#!/bin/sh

echo "Running test script..."

# get the path to the test project from args
TEST_PROJECT=$1

# get the path to the test points file from args
TEST_POINTS=$2

# get the path for the ouptput json
OUTPUT_JSON=$3

# run cargo test on the test project
cargo test $TEST_PROJECT --message-format json -- -Z unstable-options --format json > cargo.json

# run the test script
python3 /home/rust-196-test -I cargo.json -T $TEST_POINTS -O $OUTPUT_JSON

echo "Wrote test results to $OUTPUT_JSON."

# delete cargo.json
rm cargo.json

