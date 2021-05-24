# -----------------
# Cargo Build Stage
# -----------------

FROM rust:1.39 as cargo-build

WORKDIR /usr/src/app
COPY Cargo.lock .
COPY Cargo.toml .
RUN mkdir .cargo
RUN cargo vendor > .cargo/config

COPY ./src src
RUN cargo build --release
RUN cargo install --path . --verbose

# -----------------
# Final Stage
# -----------------

FROM debian:stable-slim

COPY --from=cargo-build /usr/local/cargo/bin/my_binary /bin

CMD ["my_binary"]
