FROM buildpack-deps:bookworm-curl@sha256:89f0653a0a912939914d7df4bfbf6b6759e1713ac7307b734d205628eb195879 AS fetch

WORKDIR /fetch

COPY fetch-dotslash fetch-dotslash
RUN ./fetch-dotslash

COPY jq .
RUN echo '{"foo":0}' | ./dotslash ./jq .

FROM debian:bookworm-slim@sha256:d02c76d82364cedca16ba3ed6f9102406fa9fa8833076a609cabf14270f43dfc

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=fetch /fetch/dotslash /usr/bin
