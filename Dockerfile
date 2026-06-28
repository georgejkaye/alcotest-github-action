FROM ocaml/opam:debian-ocaml-5.5

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]