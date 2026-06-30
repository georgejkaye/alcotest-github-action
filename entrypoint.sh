#!/bin/sh

PROJECT_DIR=$1

pushd $PROJECT_DIR > /dev/null
RUNTEST_OUTPUT=$(ALCOTEST_COLOR=never opam exec -- dune runtest 3>&2 2>&1 1>&3)
popd > /dev/null

dune exec alcotest_action "$RUNTEST_OUTPUT"