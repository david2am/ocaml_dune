# OCaml/Dune Tutorial

This tutorial is based on the official OCaml documentation and the video [Getting Started with OCaml with Pedro Cattori...](https://www.youtube.com/watch?v=FtI5hxDcVKU&t=2190s). Thank you for creating such an amazing video! More project-oriented tutorials are needed to help developers learn OCaml effectively. This tutorial is my contribution to the community. 🫰

## References

- [OCamlVerse](https://ocamlverse.net/content/quickstart_ocaml_project_dune.html)
- [Dune Documentation](https://dune.readthedocs.io/en/stable/tutorials/developing-with-dune)

_Note:_ This article also includes notes for OCaml maintainers. The OCaml community is welcoming, and I trust that my feedback will be well-received.

Happy coding! 🚀

---

# OCaml Global Setup

## Install OCaml

As usual install the basics, in this case it's `Opam`, the OCaml's package manager (similar to **npm** in JS) that manages packages and compiler versions.

```sh
brew install opam
```

## Setup OCaml Globally

The next step is to set OCaml's global configuration with Opam:

```sh
opam init -y
```

And activate the **Opam** global configuration activating its env variables by running:

```sh
eval $(opam env)
```

_Note:_ every time you open a new terminal you need to run `eval $(opam env)` to activate the **Opam** global config, my recommendation is add this command to your `.bashrc` or `.zshrc` file, so everytime you open a new terminal you activate it.

## Install Platform Tools

Platform tools assist your code editor with the **OCaml LSP server** and help you to create and manage OCaml projects with **Dune**.

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

---

---

# Create and Run a Project

## Create a Project

**Dune** is the default OCaml's build system to automatize: compilations, tests, and document generation, with it you can also create and manage your projects, if you run the last commands you installed it, so you can freely create a new project by running:

```sh
dune init proj [project_name]
cd [project_name]
```

---

## Project Structure

Most of the work would happen in the `lib/` folder, and the `main.ml` file that is the application entry point. Files in Dune are composed mainly by two types of files: `.ml` files, that correspond to modules where the OCaml code resides, and `dune` files that contains metadata from those modules in **s-exrpression** format.

- `lib/` - Contains your modules, alias your `.ml` files.
- `bin/` - Contains executable/compiled programs.
- `_opam/` — Stores project dependencies.
- `_build/` — Contains build artifacts.
- `dune-project` — Equivalent to package.json in JavaScript or requirements.txt in Python.
- `bin/main.ml` — The application’s entry point.

---

## Create a Switch for Your Project

Switches in OCaml are similar to Python's virtual environments. They keep compilers and package versions isolated per project, helping you avoid conflicts between them.

```sh
opam switch create . [compiler_version] --deps-only
```

As a result **Opam** create and store Switch artifacts in the `_opam/` folder.

- The `--deps-only` flag ensures that only dependencies are installed, and not the current project as another dependency (which is common practice in systems programming).

### Help **Opam** to Automatically Detect If You Are in the Right Switch

Run this command once:

```sh
opam init --enable-shell-hook
```

### Activate the Switch

Every time you get into a project don't forget to activate the Switch by running:

```ml
eval $(opam env)
```

## Install Dev Tools for the New Switch

This step is necessary, especially if you are using a modal code editor like **Vim**.

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

## Run the Project

As a compiled language OCaml needs to be compiled first and then execute the compiled artifacts:

```sh
dune build
dune exec [project_name]
```

But you can accomplish both by using a single command with watch mode:

```sh
dune exec -w [project_name]
```

As a result, **Dune** creates the `_build` folder containing OCaml's compiled artifacts.

## Create the `.gitignore` File

Until now a **Dune** project doesn't include a `.gitignore` file by defaul so le't create it manually:

```sh
# .gitignore
_opam/
_build/
```

## Initialize Git

```sh
git init
```

Congratulations! now you have a new project created, next, we will create a simple program and use OCaml and Dune features to build it:

---

# Create Your First Module

Let's create the typical calculator with just 2 functions: **add** and **sub** to learn about **Dune**.

## Create The Module:

In OCaml every a new `.ml` file inside the `lib/` folder is a considered a module, let's create our own as `calc.ml` and add the previous mentioned functions:

```ml
(* lib/calc.ml *)
let add x y = x + y

let sub x y = x - y
```

## Define a Library

For simplicity let's define everything inside the `lib/` folder as a library and every module inside of it as part of that library by creating a `dune` file in `lib/` and give it a the name of `math`:

```ml
(* lib/dune *)
(library
 (name math))
```

- Libraries in OCaml are similar to index files in JS, are the OCaml way to expose modules

## Register the Library in `bin/dune`

To make it possible to access your library from the `main.ml` file open the contiguous `dune` file in the `bin/` folder and register the name of your library:

```ml
(* bin/dune *)
(executable
 (public_name ocaml_dune)
 (name main)
 (libraries math)) (* Include your module *)
```

## Use the Module in `main.ml`

You can access a module by writing the library name followed by the module name like `Library.Module`, but usually you will prefer to use **open** to access the module in your `main.ml` as follows:

In the `bin/` folder, open the `main.ml` file, access the library with the `open` keyword followed by the library name, and call your module definitions by writing the module name followed by its definition like `Module.definition`:

```ml
(* bin/main.ml *)
open Math

let () =
  let result = Calc.add 2 3 in
  print_endline (Int.to_string result); (* Output: 5 *)

  let result = Calc.sub 3 1 in
  print_endline (Int.to_string result) (* Output: 2 *)
```

- Notice that we are also using a definition from the `Int` module from the standard library to convert a number to a string.

## Run the Project

Compile and execute your project in watch mode by using this command:

```sh
dune exec -w [project_name]
```

---

# Interface Files (`.mli`)

`.mli` files are OCaml interface files, they serves as:

- _Module interface definition_: define the public interface of a module.
- _Encapsulation_: prevents accidental exposure of internal details of a module.
- _Documentation_: can include comment specifications that gives more clarity to other developers.
- _Separation of interface and implementation_: you can change the internals of a module without affecting other parts of the program, as long as the public interface remains the same.
- _Improve compilation time_: the compiler relies on them to speed up.

## Define the module’s public API

It's enough to create an `.mli` file with with the same name of its correspondin molude, in this case create `calc.mli` at one side of `calc.ml` in the `lib/` folder:

```ml
(* lib/calc.mli *)
val add : int -> int -> int
(** [add x y] returns the sum of x and y. *)
```

If you verify your running program in the terminal, attempting to use `sub` will now result in an error, to fix it expose it also in `calc.mli`:

```ml
(* lib/calc.mli *)
val add : int -> int -> int
(** [add x y] returns the sum of x and y. *)

val sub : int -> int -> int
(** [sub x y] returns the difference of x and y. *)
```

---

# Feedback for OCaml Maintainers

- A direct link to available compiler versions in the switch documentation would be helpful to find more available versions.
- `--deps-only`
  - Installing packeges without considering the current project could be the default behavior to simplify the setup.
- `eval $(opam env)`
  - Automate this every time a switch is activated would improve the developer experience.
- `dune exec -w [project_name]`
  - Avoid writing the project name to run the project simplifies the setup.
  - It would be nice if it automatically creates a `.gitignore file` so we don't have to do it manually.

<!-- - It would be great if we don't have to define a `dune` file for each module, and instead this would be the default behavior -->
