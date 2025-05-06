# OCaml/Dune Tutorial

This tutorial is based on the official OCaml documentation and the video [Getting Started with OCaml with Pedro Cattori...](https://www.youtube.com/watch?v=FtI5hxDcVKU&t=2190s). Thank you for creating such an amazing video! More project-oriented tutorials are needed to help developers learn OCaml effectively. This tutorial is my contribution to the community. 🫰

## References

- [OCamlVerse](https://ocamlverse.net/content/quickstart_ocaml_project_dune.html)
- [Dune Documentation](https://dune.readthedocs.io/en/stable/tutorials/developing-with-dune)

_Note:_ This article also includes notes for OCaml maintainers. The OCaml community is welcoming, and I trust that my feedback will be well-received.

---

# OCaml Global Setup

## Install OCaml

Start by installing **Opam**, the OCaml package manager, which is similar to **npm** in JavaScript. It manages packages and compiler versions.

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

## Setup OCaml Globally

Initialize OCaml's global configuration with Opam:

```sh
opam init -y
```

Activate the **Opam** global configuration by running:

```sh
eval $(opam env)
```

_Note:_ You need to run `eval $(opam env)` every time you open a new terminal to activate the **Opam** global configuration. Consider adding this command to your `.bashrc` or `.zshrc` file to automate this process.

### Install Platform Tools

Install essential tools to assist your code editor with the **OCaml LSP server** and help you create and manage OCaml projects with **Dune**:

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

These tools provide:

- `ocaml-lsp-server`: Language server for editor integration (code completion, etc.)
- `odoc`: Documentation generator
- `ocamlformat`: Code formatter
- `utop`: Enhanced REPL (interactive console)
- `dune`: Build system and project manager

---

# Create and Run a Project

## Create a Project

**Dune** is OCaml's default build system, automating compilations, tests, and documentation generation. It also helps create and manage projects. If you've run the previous commands, Dune is already installed. Create a new project by running:

```sh
dune init proj my_project
cd my_project
```

## Project Structure

Most of your work will happen in the `lib/` folder and the `main.ml` file, which is the application's entry point. Dune projects primarily consist of:

- `lib/`: Contains your modules (`.ml` files).
- `bin/`: Contains executable/compiled programs.
- `_opam/`: Stores project dependencies.
- `_build/`: Contains build artifacts.
- `dune-project`: Equivalent to `package.json` in JavaScript or `requirements.txt` in Python.
- `bin/main.ml`: The application’s entry point.

## Create a Switch for Your Project

Switches in OCaml are similar to Python's virtual environments. They isolate compilers and package versions per project, preventing conflicts.

List available compiler versions:

```sh
opam switch list-available
```

Create a switch with your selected version:

```sh
opam switch create . 5.3.0 --deps-only
```

This command creates and stores switch artifacts in the `_opam/` folder. The `--deps-only` flag ensures that only dependencies are installed, not the current project.

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

This step is necessary, especially if you use a modal code editor like **Vim**:

```sh
opam install ocaml-lsp-server odoc ocamlformat
```

## Run the Project

Compile and execute your project:

```sh
dune build
dune exec my_project
```

Alternatively, use watch mode to accomplish both tasks with a single command:

```sh
dune exec -w my_project
```

This creates the `_build/` folder containing OCaml's compiled artifacts.

## Create the `.gitignore` File

Dune projects do not include a `.gitignore` file by default. Create it manually:

```sh
# .gitignore
_opam/
_build/
```

## Initialize Git

```sh
git init
```

Congratulations! You have created a new project. Next, we will create a simple program using OCaml and Dune features.

---

# Create Your First Module

Let's create a simple calculator with `add` and `sub` functions to learn about **Dune**.

## Create the Module

In OCaml, each `.ml` file in the `lib/` folder is considered a module. Create `calc.ml` and add the following functions:

```ml
(* lib/calc.ml *)
let add x y = x + y

let sub x y = x - y
```

## Define a Library

Define everything inside the `lib/` folder as a library named `math` by creating a `dune` file in `lib/`:

```scheme
; lib/dune
(library
 (name math))
```

Libraries in OCaml are similar to index files in JavaScript; they expose modules.

## Register the Library in `bin/dune`

To access your library from `main.ml`, open the `dune` file in the `bin/` folder and register the library name:

```scheme
; bin/dune
(executable
 (public_name ocaml_dune)
 (name main)
 (libraries math)) ; Include your module here
```

## Use the Module in `main.ml`

Access the library in `main.ml` using the `open` keyword, and call your module definitions:

```ml
(* bin/main.ml *)
open Math

let () =
  let result = Calc.add 2 3 in
  print_endline (Int.to_string result); (* Output: 5 *)

  let result = Calc.sub 3 1 in
  print_endline (Int.to_string result) (* Output: 2 *)
```

Notice that we also use the `Int` module from the standard library to convert a number to a string.

## Run the Project

Compile and execute your project in watch mode:

```sh
dune exec -w my_project
```

---

# Interface Files (`.mli`)

`.mli` files are OCaml interface files. They serve as:

- _Module interface definition_: Define the public interface of a module.
- _Encapsulation_: Prevent accidental exposure of internal module details.
- _Documentation_: Include comments for clarity.
- _Separation of interface and implementation_: Change module internals without affecting other program parts.
- _Improve compilation time_: The compiler relies on them to speed up.

## Define the Module’s Public API

Create an `.mli` file with the same name as its corresponding module. For `calc.ml`, create `calc.mli` in the `lib/` folder:

```ml
(* lib/calc.mli *)
val add : int -> int -> int
(** [add x y] returns the sum of x and y. *)
```

If you attempt to use `sub` in your running program, it will result in an error. Expose `sub` in `calc.mli` to fix this:

```ml
(* lib/calc.mli *)
val add : int -> int -> int
(** [add x y] returns the sum of x and y. *)

val sub : int -> int -> int
(** [sub x y] returns the difference of x and y. *)
```

---

# Add a Dependency

Let's add **ANSITerminal**, a lightweight package for colored terminal output.

## Subscribe the Module in `dune-project`

Edit your `dune-project` file and add the dependency name in the `depends` node:

```scheme
...
(package
 (name my_project)
 (depends
  ocaml
  (ANSITerminal (>= 0.8.5))) ; add package here
```

## Install the Module

Run `dune build` to automatically install the dependency:

```sh
dune build
```

Alternatively, you can run:

```sh
opam install ANSITerminal
```

However, `dune build` is recommended because it creates the `ocaml_dune.opam` file, similar to `package.lock.json` in JavaScript, maintaining a register of the exact package versions.

## Import the Module

Update the `dune` file in the `bin/` folder to include the new dependency:

```scheme
(executable
 (public_name ocaml_dune)
 (name main)
 (libraries math ANSITerminal)) ; add package here
```

## Update `main.ml`

```ml
(* Import the module *)
open ANSITerminal

(* Print nicely formatted text in the terminal *)
let () =
  print_string [Bold; green] "\n\nHello in bold green!\n";
  print_string [red] "This is in red.\n"
```

---

# Testing

Alcotest is a simple and efficient testing framework for OCaml. It provides a straightforward way to write and run tests, making it easier to ensure the reliability and correctness of your code. This is the tool we are going to use.

## Add Alcotest to `dune-project` Dependencies

To integrate Alcotest into your project, you need to add it as a dependency in your `dune-project` file. This ensures that Alcotest is available for your test suite.

```scheme
(package
 (name my_project)
 (depends
  ocaml
  (ANSITerminal (>= 0.8.5))
  (alcotest :with-test))) ; Add Alcotest as a test-only dependency
```

The `:with-test` constraint specifies that **Alcotest** is a test-only dependency, meaning it will only be used during testing and not included in the final build.

## Install the Dependency

After updating the `dune-project` file, install the dependency by running:

```sh
opam install alcotest
```

And then:

```sh
dune build
```

This registers the dependency in the `ocaml_dune.opam` file, which serves a similar purpose to `package.lock.json` in other ecosystems.

## Register Alcotest in the Test `dune` File

Next, you need to register Alcotest and your libraries for your tests. This is done in the `test/dune` file:

```scheme
(test
 (name test_my_project)
 (libraries alcotest math)) ; Include Alcotest and your math library
```

By doing this, any `.ml` files in the `test/` folder will have access to both Alcotest and your library's modules.

## Create Your First Dummy Test

Now, create a simple test to ensure everything is set up correctly. Add the following code to the `test/test_my_project.ml` file:

```ocaml
(* test/test_my_project.ml *)
let test_hello () =
  Alcotest.(check string) "same string" "hello" "hello"

let () =
  Alcotest.run "My Project" [
    "hello", [
      Alcotest.test_case "Hello test" `Quick test_hello;
    ];
  ]
```

This dummy test checks if the string "hello" is equal to "hello", which should always pass. It's a good starting point to verify that your testing setup is functional.

## Run the Test

```sh
dune test
```

---

# Next Steps

- Explore the standard library in the [OCaml Manual](https://ocaml.org/manual)
- Try [Real World OCaml](https://dev.realworldocaml.org/)
- Browse packages on [OCaml Packages](https://ocaml.org/packages)

---

Happy coding with OCaml! 🚀

---

# Feedback for OCaml Maintainers

- A direct link to available compiler versions in the switch documentation would be helpful.
- `--deps-only`: Installing packages without considering the current project could be the default behavior to simplify the setup.
- `eval $(opam env)`: Automating this command every time a switch is activated would improve the developer experience.
- `dune exec -w my_project`: Avoid writing the project name to run the project, simplifying the setup.
- Automatically create a `.gitignore` file to avoid manual setup.
- We should include a `dune` CLI command to install a package, register the library name in the `dune-project` and update the `ocaml_dune.opam` file.
- It would be great if we didn't have to define a `dune` file for each module, and instead, this would be the default behavior
