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
