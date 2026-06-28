#!/bin/sh

opam init -y --disable-sandboxing --shell-setup
opam switch create . --disable-sandboxing --jobs=8 --locked

eval $(opam env)

dune runtest