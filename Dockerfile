FROM ocaml/opam:debian-12-ocaml-5.5 AS builder

WORKDIR /action

COPY dune-project .
COPY alcotest_action.opam .

RUN opam init
RUN opam install . --deps-only

COPY bin bin
COPY lib lib

RUN eval $(opam env); dune build

FROM debian:12 AS runner

WORKDIR /action

RUN mkdir /github/workspace

COPY --from=builder /action/_build/default/bin/main.exe /action/main.exe

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/action/entrypoint.sh" ]
