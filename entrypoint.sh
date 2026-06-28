#!/bin/sh

echo "about to ls"
ls -R ~/.opam
echo "did the ls"
opam init --disable-sandboxing -y
opam switch create .--jobs=8 --locked

eval $(opam env)

dune runtest