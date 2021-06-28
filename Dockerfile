# pull from the latest Alpine image
FROM alpine:latest

# update and upgrade the Alpine package manager
RUN apk update
RUN apk upgrade 

# create the /grade directory for PL
RUN mkdir /grade

# set the working directory to /grade
WORKDIR /grade

# create subdirectories of the /grade directory for PL grading
RUN mkdir results
RUN mkdir serverFilesCourse
RUN mkdir student
RUN mkdir tests
RUN mkdir bin

# install Rust and Cargo
RUN apk add --no-cache rust cargo

# Install python3 and pip
RUN apk add --no-cache python3 py3-pip

# create a project to grade rust assignments
# when grading, copy source files to this folder
RUN cargo new bin/rust-grader

# add any required dependencies for grading to Cargo.toml
# run cargo build to compile required dependencies
# when the student source files are copied over, the binaries will already be built
# source: https://stackoverflow.com/a/42139535
ADD Cargo.toml bin/rust-grader/Cargo.toml
RUN cd bin/rust-grader && cargo build

# create a folder to grade python assignments
# when grading, copy source files to this folder
RUN mkdir bin/python-grader

# install required python dependencies with pip
ADD requirements.txt bin/python-grader/requirements.txt
RUN pip3 install -r bin/python-grader/requirements.txt