#!/bin/sh

opam init -y --disable-sandboxing
opam switch create .--jobs=8 --locked

eval $(opam env)

dune runtest