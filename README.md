# OCaml/Dune Tutorial

This tutorial is based on the official OCaml documentation and the video [Getting Started with OCaml with Pedro Cattori...](https://www.youtube.com/watch?v=FtI5hxDcVKU&t=2190s). Thank you for creating such an amazing video! More project-oriented tutorials are needed to help developers learn OCaml effectively. This tutorial is my contribution to the community. 🫰

## References

- [OCamlVerse](https://ocamlverse.net/content/quickstart_ocaml_project_dune.html)
- [Dune Documentation](https://dune.readthedocs.io/en/stable/tutorials/developing-with-dune)

*Note:* This article also includes notes for OCaml maintainers. The OCaml community is welcoming, and I trust that my feedback will be well-received.

 Happy coding! 🚀

---

# OCaml Initial Setup

## Installing OCaml

```sh
brew install opam
opam init -y
eval $(opam env)
```

- [Reference](https://ocaml.org/docs/installing-ocaml)  

*Note:* You need to run `eval $(opam env)` every time you open a new terminal. To automate this, add the command to your `.bashrc` or `.zshrc` file.

**opam** is OCaml's package manager, similar to **npm** in the web development world. It manages packages and compiler versions.

## Installing Essential Tools

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

These platform tools assist in writing and managing OCaml projects. They include the **OCaml LSP server** and **Dune**.

**Dune** is OCaml's build system, automating compilation, testing, and documentation generation.

---

# Setting Up a New Project

## Creating and Running a New Project

```sh
dune init proj {project_name}
dune build
dune exec {project_name}
```

- [Reference](https://dune.readthedocs.io/en/stable/quick-start.html)  

## Initializing Git and `.gitignore`

Create a `.gitignore` file:

```sh
# .gitignore
_opam/
_build/
```

Initialize your Git repository:

```sh
git init
```

## Creating a New Switch

```sh
opam switch create . {compiler_version} --deps-only
opam init --enable-shell-hook
eval $(opam env)
```

**opam switch** is similar to Python's virtual environments. It isolates compilers and package versions for different projects, preventing conflicts.

- The `--deps-only` flag ensures that only dependencies are installed, not the current project.
- `opam init --enable-shell-hook` is needed only once to enable automatic switch handling.
- You still need to run `eval $(opam env)` each time you switch projects.

- [Reference](https://ocaml.org/docs/opam-switch-introduction#creating-a-new-switch)  

*Note:* Running `--deps-only` is similar to running `npm install` in JavaScript projects.

### Feedback for OCaml Maintainers

- A direct link to available compiler versions in the switch documentation would be helpful.
- Making `--deps-only` the default behavior could simplify setup.
- Avoiding the need to manually run `eval $(opam env)` every time a switch is activated would improve the developer experience.

## Installing Tools for the New Switch

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

This step is especially necessary if you use a modal code editor like Vim or Helix.

---

# Understanding Project Structure

Your OCaml code resides in `.ml` files, each accompanied by a `dune` file containing metadata used by **Dune**. This metadata is written in S-expression format, similar to how GitHub Actions use `YAML` or JavaScript projects use `JSON`.

### Folder Structure Overview

- `lib/` - Contains your Ocaml modules, alias (your reusable code)
- `bin/` - Contains your executable programs,  (*"the code"*)
- `_opam/` — Stores project dependencies.
- `_build/` — Contains build artifacts.
- `dune-project` — Equivalent to package.json in JavaScript or requirements.txt in Python.
- `bin/main.ml` — The application’s entry point.



# Creating Your First Module

## Defining a Library Module

Create a `dune` file for your module:

```ml
(* lib/dune *)
(library
 (name lib))
```

Create your module:

```ml
(* lib/math.ml *)
let add x y = x + y
let sub x y = x - y
```

## Registering the Module in `bin/dune`

```ml
(* bin/dune *)
(executable
 (public_name ocaml_dune)
 (name main)
 (libraries lib)) (* Include your module *)
```

## Using the Module in `main.ml`

```ml
(* bin/main.ml *)
open Lib (* Import your module *)

let () =
  let result = Math.add 2 3 in
  print_endline (Int.to_string result); (* Output: 5 *)
  let result = Math.sub 3 1 in
  print_endline (Int.to_string result) (* Output: 2 *)
```

## Running the Project

```sh
dune exec -w {project_name}
```

OCaml is a compiled language, meaning execution involves two steps:
1. **Build**
2. **Execute**

The above command combines both steps, and the `-w` flag enables watch mode.

*Note:* **Dune** creates a `_build` folder containing OCaml's compiled artifacts.

---

# Creating an Interface File (`.mli`)

By default, all expressions in `math.ml` are accessible in `main.ml`. To control visibility, create an **interface file** (`.mli`) that defines the module’s public API.

```ml
(* lib/math.mli *)
val add : int -> int -> int
(** [add x y] returns the sum of x and y. *)
```

Attempting to use `sub` will now result in an error. To expose it, update `math.mli`:

```ml
(* lib/math.mli *)
val add : int -> int -> int
(** [add x y] returns the sum of x and y. *)

val sub : int -> int -> int
(** [sub x y] returns the difference of x and y. *)
```
