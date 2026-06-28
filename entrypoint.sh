#!/bin/sh

RUN opam init -y --disable-sandboxing --shell-setup
opam switch create . --jobs=8 --locked

eval $(opam env)

dune runtest