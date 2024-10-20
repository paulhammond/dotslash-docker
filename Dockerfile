FROM buildpack-deps:bookworm-curl@sha256:89f0653a0a912939914d7df4bfbf6b6759e1713ac7307b734d205628eb195879 AS fetch

WORKDIR /fetch

COPY fetch-dotslash fetch-dotslash
RUN ./fetch-dotslash

COPY jq .
RUN echo '{"foo":0}' | ./dotslash ./jq .

FROM debian:bookworm-slim@sha256:36e591f228bb9b99348f584e83f16e012c33ba5cad44ef5981a1d7c0a93eca22

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=fetch /fetch/dotslash /usr/bin

CMD /usr/bin/dotslash
