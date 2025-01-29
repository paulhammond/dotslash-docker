FROM buildpack-deps:bookworm-curl@sha256:104f8217967876111a4e8f72495f5f0989a2d6b9c2b91622ddf66e7371df6e36 AS fetch

WORKDIR /fetch

COPY fetch-dotslash fetch-dotslash
RUN ./fetch-dotslash

COPY jq .
RUN echo '{"foo":0}' | ./dotslash ./jq .

FROM debian:bookworm-slim@sha256:f70dc8d6a8b6a06824c92471a1a258030836b26b043881358b967bf73de7c5ab

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=fetch /fetch/dotslash /usr/bin

CMD /usr/bin/dotslash
