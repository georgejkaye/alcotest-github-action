FROM ocaml/opam:debian-12-ocaml-5.5 AS base

WORKDIR /home/opam/action

COPY --chown=opam:opam *.opam dune-project ./


FROM base AS builder

RUN \
    --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=locked,uid=1000,gid=1000 \
    opam update && \
    opam install . --deps-only -y

COPY bin bin
COPY lib lib

RUN opam exec -- dune build bin

FROM scratch AS builder_workspace

COPY --from=builder /home/opam/action /

FROM base AS tester

RUN \
    --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=locked,uid=1000,gid=1000 \
    opam update && \
    opam install . --deps-only --with-test -y

COPY bin bin
COPY lib lib
COPY test test

RUN opam exec -- dune build test

FROM scratch AS tester_workspace

COPY --from=tester /home/opam/action /

FROM debian:12 AS runner

WORKDIR /action

RUN mkdir -p /github/workspace

COPY --from=builder /home/opam/action/_build/default/bin/main.exe /home/opam/action/main.exe

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/action/entrypoint.sh" ]
