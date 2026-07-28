FROM ocaml/opam:debian-ocaml-5.5

WORKDIR /action

COPY dune-project .
COPY alcotest_action.opam .

RUN opam init
RUN opam install . --deps-only

COPY bin bin
COPY lib lib

RUN eval $(opam env); dune build

COPY entrypoint.sh entrypoint.sh

ENTRYPOINT [ "/action/entrypoint.sh" ]