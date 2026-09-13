FROM ocaml/opam:debian-12-ocaml-5.5 AS builder

WORKDIR /action

COPY dune-project .
COPY alcotest_action.opam .

RUN \
    --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=shared,uid=1000,gid=1000 \
    opam update && \
    opam install . --deps-only -y

COPY bin bin
COPY lib lib

RUN opam exec -- dune build bin

FROM scratch AS build_workspace

COPY --from=builder /home/opam/app /

FROM builder AS tester

RUN \
    --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=shared,uid=1000,gid=1000 \
    opam update && \
    opam install . --deps-only --with-test

COPY test test

RUN opam exec -- dune build test

FROM scratch AS test_workspace

COPY --from=tester /home/opam/app /

FROM debian:12 AS runner

WORKDIR /action

RUN mkdir -p /github/workspace

COPY --from=builder /action/_build/default/bin/main.exe /action/main.exe

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/action/entrypoint.sh" ]
