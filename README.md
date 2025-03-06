# Ocaml Initial Setup

## Install Ocaml

```sh
brew install opam
opam init -y
eval $(opam env)
```

- [reference](https://ocaml.org/docs/installing-ocaml)
- *Note:* It's necessary to add Ocaml's env variables through `eval $opam env`
  everytime you enter in a new terminal, so maybe you are interested to add the
  command to your `.bashrc` or `.zshrc` file

**opam** is the Ocaml's package manager, if you came from the web, it's equivalent to
**npm**; it handles your *packages* and also your *switches* (more of this below ;)).

## Install Platform Tools

Platform tools are going to help you write your Ocaml code and projects, it includes the
lsp-server and dune.

```sh
opam install ocaml-lsp-server odoc ocamlformat utop dune
```

**dune** is Ocaml's build system, it automates compilation, testing, documentation
generation and other build tasks.


# New Project Setup

## Create an Execute a New Project

Use Dune to create a new project

```sh
dune init proj {project_name}
dune build
dune exec {project_name}
```

- [reference](https://dune.readthedocs.io/en/stable/quick-start.html)

## Setup Git

Create a `.gitignore` file

```sh
# .gitignore
_opam/
```

Init git

```sh

git init
```


## Create a Switch

```sh
opam switch create . {compiler_version} --deps-only --locked
# automatically move to the current switch:
opam init --enable-shell-hook
eval $(opam env)
```

**opam switch** is similar to Python's virtual environments,its purpose is to isolate
different compilers and package versions in your projects. The `--deps-only` flag tells
you to install packages only, otherwise it will treat your current project as a package
to be built and installed.

- [reference](https://ocaml.org/docs/opam-switch-introduction#creating-a-new-switch)
- *Note:* running `--deps-only` is basically running `npm install` in the web world
- *Note:* running `--locked` ensures that only specific versions in `opam.lock` are
  installed
- *Note:* `opam init --enable-shell-hook` is needed to run just once, it automatically
  updates your switch from one project to another, but it's still necessary to activate
  your switch env variables every time by running `eval $(opam env)`. 
- *Note for Ocaml maintainers:*
  1. it would be great if we could find a link to a list of the different compiler versions
     directly in the switch docs.
  2. what if instead of writing `ocaml-base-compiler.5.2.1` as the compiler version we could
     use like `ocaml.5` and bring the LTS current version unless we choose a specific
     version?
  3. it's not clear for me why we should use `--deps-only` have you considered this as the
     default behavior? so we could avoid to be aware of having to write this, (althoug maybe
     it's a different mindset and I have to adapt)

