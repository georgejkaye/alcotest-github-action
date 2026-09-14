FROM ocaml/opam:debian-12-ocaml-5.5 AS base

WORKDIR /home/opam/action

COPY --chown=opam:opam *.opam dune-project ./

ENV DUNE_CACHE=enabled
ENV DUNE_CACHE_STORAGE_MODE=copy

FROM base AS builder

RUN \
    --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=locked,uid=1000,gid=1000 \
    --mount=type=cache,target=/home/opam/.cache.dune,sharing=locked,uid=1000,gid=1000 \
    opam update && \
    opam install . --deps-only -y

COPY bin bin
COPY lib lib

RUN opam exec -- dune build bin

FROM base AS tester

RUN \
    --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=locked,uid=1000,gid=1000 \
    opam update && \
    opam install . --deps-only --with-test -y

COPY bin bin
COPY lib lib
COPY test test

RUN opam exec -- dune build test

FROM debian:12 AS runner

WORKDIR /home/opam/action

RUN mkdir -p /github/workspace

COPY --from=builder /home/opam/action/_build/default/bin/main.exe /home/opam/action/main.exe

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/action/entrypoint.sh" ]
