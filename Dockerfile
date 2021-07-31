# pull from the latest Alpine image
FROM alpine:latest

# set the user env variable
ENV USER='grader'

# update and upgrade the Alpine package manager
RUN apk update
RUN apk upgrade 

# install Rust and Cargo
RUN apk add --no-cache rust cargo

# Install python3 and pip
RUN apk add --no-cache python3 py3-pip

# create a project to grade rust assignments
# when grading, copy source files to this folder
RUN cargo new home/rust-grader

# add any required dependencies for grading to Cargo.toml
# run cargo build to compile required dependencies
# when the student source files are copied over, the binaries will already be built
# source: https://stackoverflow.com/a/42139535
ADD Cargo.toml home/rust-grader/Cargo.toml
RUN cd home/rust-grader && cargo build

# install required python dependencies with pip
ADD requirements.txt home/python-grader/requirements.txt
RUN pip3 install -r home/python-grader/requirements.txt

# copy run-test.sh script to /bin
ADD run-test.sh /bin/run-test
RUN chmod 755 /bin/run-test