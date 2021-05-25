# -----------------
# Cargo Build Stage
# -----------------

FROM rust:1.52 as cargo-build

WORKDIR /usr/src/app
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

COPY --from=cargo-build /usr/local/cargo/bin/rust-autograder /bin

CMD ["rust-autograder"]

# -----------------
# Python Stage
# -----------------

FROM centos:7

COPY python-requirements.txt /

RUN echo "installing python and curl" \
        && yum -y install \
        git \
        python3 \
        python3-pip \
        python3-devel \
        curl
RUN yum clean all
RUN echo "installing node via nvm" \
    && git clone https://github.com/creationix/nvm.git /nvm \
    && cd /nvm \
    && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` \
    && source /nvm/nvm.sh \
    && export NVM_SYMLINK_CURRENT=true \
    && nvm install 12 \
    && npm install npm@latest -g \
    && for f in /nvm/current/bin/* ; do ln -s $f /usr/local/bin/`basename $f` ; done
RUN echo "setting up python3..." \
    && python3 -m pip install --no-cache-dir -r /python-requirements.txt \