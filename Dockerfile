FROM ocaml/opam:debian-ocaml-5.5

RUN opam init -y --disable-sandboxing --shell-setup
RUN opam install opam-0install
RUN opam option solver=builtin-0install
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]