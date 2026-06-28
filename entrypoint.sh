#!/bin/sh

ls -R ~/.opam
opam init --disable-sandboxing -y
opam switch create .--jobs=8 --locked

eval $(opam env)

dune runtest