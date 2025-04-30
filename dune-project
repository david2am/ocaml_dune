(lang dune 3.17)

(name ocaml_dune)

(generate_opam_files true)

(source
 (github david2am/reponame))

(authors "David @ dvccueter@gmail.com")

(maintainers "Maintainer Name <maintainer@example.com>")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name ocaml_dune)
 (synopsis "Learn Ocaml in Dune from the ground up")
 (description "This is an begginer's Ocaml tutorial")
 (depends
  ocaml
  (ANSITerminal (>= 0.8.5))
  (alcotest :with-test))
 (tags
  ("ocaml" "dune" "begginer" "tutorial")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
