FROM buildpack-deps:bookworm-curl@sha256:138493088fe1e6bf6bae848411a3c07428649d0cc4664974d48f7a171608f9be AS fetch

WORKDIR /fetch

COPY fetch-dotslash fetch-dotslash
RUN ./fetch-dotslash

COPY jq .
RUN echo '{"foo":0}' | ./dotslash ./jq .

FROM debian:bookworm-slim@sha256:e5865e6858dacc255bead044a7f2d0ad8c362433cfaa5acefb670c1edf54dfef

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=fetch /fetch/dotslash /usr/bin

CMD /usr/bin/dotslash
