(lang dune 3.23)

(name alcotest_action)

(generate_opam_files true)

(source
 (github georgejkaye/alcotest-github-action))

(authors "George Kaye <georgejkaye@gmail.com>")

(maintainers "George Kaye <georgejkaye@gmail.com>")

(license GPL-3.0-or-later)

(documentation https://github.com/georgejkaye/alcotest-github-action/README.md)

(package
 (name alcotest_action)
 (synopsis "GitHub Action to process OCaml Alcotest suites")
 (description "GitHub Action to process OCaml Alcotest suites")
 (depends ocaml core core_unix)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
