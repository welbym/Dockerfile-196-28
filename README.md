# Dockerfile-196-28
Dockerfile for 196-28 Rust and Python autograding.
Source files for Rust assignments should be copied to the `rust-grader` folder.
Source files for Python assignments should be copied to the `python-grader` folder.

## Build Instructions
build `Dockerfile`: `docker build -t welbym/rust-196-28-autograder:latest .`
push `Dockerfile`: `docker push welbym/rust-196-28-autograder:latest`
