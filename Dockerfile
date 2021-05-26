# -----------------
# Cargo Build Stage
# -----------------

FROM rust:1.52 as cargo-build

WORKDIR /usr/src/rust-autograder
COPY Cargo.lock .
COPY Cargo.toml .
COPY src/main.rs .
RUN mkdir .cargo

RUN cargo build --release
COPY ./src src
RUN cargo install --path . --verbose

RUN cargo vendor > .cargo/config

# -----------------
# Final Stage
# -----------------

FROM debian:stable-slim

COPY --from=cargo-build /usr/local/cargo/bin/rust-autograder /usr/local/bin/rust-autograder

CMD ["rust-autograder"]

# -----------------
# Python Stage
# -----------------

FROM centos:7

# Needed for AWS to properly handle UTF-8
ENV PYTHONIOENCODING=UTF-8

COPY python-requirements.txt /

RUN echo "installing python and curl" \
        && yum -y install \
        git \
        python3 \
        python3-pip \
        python3-devel \
        curl \
        && yum clean all
RUN echo "setting up python3..." \
    && python3 -m pip install --no-cache-dir -r /python-requirements.txt

CMD /bin/bash 