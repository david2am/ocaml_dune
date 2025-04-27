# OCaml/Dune Tutorial

This is a summary of `Dune Turorial.md`. 🫰

---

# OCaml Global Setup

## Install Opam

### For macOS

```sh
brew install opam
```

### For Linux

```sh
sudo apt-get install opam
```

### For Windows

```sh
winget install Git.Git OCaml.opam
```

## Global Setup

Initialize OCaml's global configuration with Opam:

```sh
opam init -y
```

Activate the **Opam** global configuration by running:

```sh
eval $(opam env)
```

**Note:** add this command to your `.bashrc` or equivalent.

### Install Platform Tools

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

---

# Create and Run a Project

## Create a Project

```sh
dune init proj my_project
cd my_project
```

## Create a Switch for Your Project

List available compiler versions:

```sh
opam switch list-available
```

Create a switch with your selected version:

```sh
opam switch create . 5.3.0 --deps-only
```

### Enable Automatic Switch Detection

Run this command once to help **Opam** automatically detect if you are in the right switch:

```sh
opam init --enable-shell-hook
```

### Activate the Switch

Activate the switch every time you enter the project:

```sh
eval $(opam env)
```

## Install Dev Tools for the New Switch

```sh
opam install ocaml-lsp-server odoc ocamlformat
```

## Run the Project

```sh
dune build
dune exec my_project
```

Alternatively, use watch mode to accomplish both tasks with a single command:

```sh
dune exec -w my_project
```

## Create the `.gitignore` File

```sh
# .gitignore
_opam/
_build/
```

## Initialize Git

```sh
git init
```

---

# Add a Dependency

## Subscribe the Module in `dune-project`

```scheme
...
(package
 (name my_project)
 (depends
  ocaml
  (ANSITerminal (>= 0.8.5))) ; add package here
```

## Install the Module

```sh
dune build
```

## Import the Module

```scheme
(executable
 (public_name ocaml_dune)
 (name main)
 (libraries math ANSITerminal)) ; add package here
```

## Update `main.ml`

```ml
open ANSITerminal (* Bring the module *)

...
```

---
