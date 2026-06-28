#!/bin/sh

opam init --bare --disable-sandboxing -y
opam switch create .--jobs=8 --locked

eval $(opam env)

dune runtest