FROM rust:1.76.0-bookworm@sha256:a71cd88f9dd32fbdfa67c935f55165ddd89b7166e95de6c053c9bf33dd7381d5 AS build

WORKDIR /build

COPY dotslash dotslash
RUN cd dotslash && cargo build --release

COPY jq .
RUN echo '{"foo":0}' | dotslash/target/release/dotslash ./jq .

FROM debian:bookworm-slim@sha256:d02c76d82364cedca16ba3ed6f9102406fa9fa8833076a609cabf14270f43dfc

COPY --from=build /build/dotslash/target/release/dotslash /usr/bin
