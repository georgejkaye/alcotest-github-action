#!/bin/sh

opam switch create . --jobs=8 --locked

eval $(opam env)

dune runtest