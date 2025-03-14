- This Ocaml/Dune tutorial comes from official documentation and also from
[Getting Started with OCAML with Pedro Cattori...](https://www.youtube.com/watch?v=FtI5hxDcVKU&t=2190s).  
Thank you guys for such amazing video, I think that we need more of that to come accross to learn Ocaml for ourselves, and that is  
also my motor to write this small tuto 🫰
- [OcamlVerse](https://ocamlverse.net/content/quickstart_ocaml_project_dune.html)

*Note:* This article contains also notes for Ocaml maintainers, which is a great community and I know my feedback is
going to be well received.

# Ocaml Initial Setup

## Install Ocaml

```sh
brew install opam
opam init -y
eval $(opam env)
```

- [reference](https://ocaml.org/docs/installing-ocaml)
- *Note:* It's necessary to add Ocaml's env variables through `eval $(opam env)` everytime you enter in a new terminal, so maybe  
  you are interested to add the command to your `.bashrc` or `.zshrc` file  

**opam** is the Ocaml's package manager, if you came from the web, it's equivalent to **npm**; it handles your *packages* and also your *switches*  
(more of this below 👨‍🔧).

## Install Platform Tools

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

Platform tools are going to help you write your Ocaml code and projects, it includes the lsp-server and **dune**.  

**dune** is Ocaml's build system, it automates compilation, testing, documentation generation and other build tasks.


# New Project Setup

## Create and Execute a New Project

```sh
dune init proj {project_name}
dune build
dune exec {project_name}
```

- [reference](https://dune.readthedocs.io/en/stable/quick-start.html)

## Setup Git and `.gitignore`

Create a `.gitignore` file

```sh
# .gitignore
_opam/
_build/
```

And don't forget to init your git

```sh
git init
```


## Create a New Switch

```sh
opam switch create . {compiler_version} --deps-only
opam init --enable-shell-hook
eval $(opam env)
```

**opam switch** is like Python's virtual environments, its purpose is to isolate the compilers and package versions for different projects to  
avoid versioning conflicts between each other.  

Normally `opam init` install all your current packages and your current project as another package itself, to avoid this you explicitly use the  
`--deps-only` flag.  

`opam init --enable-shell-hook` is needed just once, it automatically updates your switch from one project to another, but it's still  
necessary to activate your switch env variables every time by running `eval $(opam env)`.

- [reference](https://ocaml.org/docs/opam-switch-introduction#creating-a-new-switch)
- *Note:* running `--deps-only` is basically running `npm install` in the web world

- *Note for Ocaml maintainers:*
  1. it would be great if we could find a link to a list of the different compiler versions directly in the switch docs.
  2. it's not clear for me why we should use `--deps-only` have you considered this as the default behavior? so we could avoid  
     to be aware of having to write this, (althoug maybe it's a different mindset and I have to adapt)
  3. it would be great if we avoid having to run `eval $(opam env)` every time

## Install Platform Tools for the Switch

```sh
opam install ocaml-lsp-server odoc ocamlformat utop
```

It's specially necessary if you are using a modal code editor like `vim` or `helix` (I'm using helix BTW!)



## General Description and Folder Structure

Your OCaml code resides in `.ml` files. Each `.ml` file is accompanied by a corresponding `dune` file, which contains metadata that **Dune**  
uses to process the `.ml` file. This metadata is written in S-expression format, the configuration language of Dune—similar to how GitHub  
Actions use `YAML` or Node.js projects use `JSON`.

### The folder structure:

- `lib` folder contains your Ocaml modules, alias your reusable code 
- `bin` folder contains your executable programs, alias *"the code"*
- `_opam` folder contains your project dependencies

- `dune-project` file is your `package.json` equivalent in JavaScript or your `requirements.txt` equivalent in Python.
- `bin/main.ml` is your entry point



# Create Your First Module

Create your first `dune` file

```ml
(* lib/dune *)
(library
 (name lib))
```

Create your new module:

```ml
(* lib/math.ml *)
let add x y = x + y

let sub x y = x - y
```

Register your module to make it accessible from the `main.ml` file in `bin/dune`

```ml
(* bin/dune *)
(executable
 (public_name ocaml_dune)
 (name main)
 (libraries lib)) (* add this line *)
```

Use it!

```ml
(* bin/main.ml *)
open Lib (* import your module *)

let () =
  let result = Math.add 2 3 in
  print_endline (Int.to_string result); (* ans: 5 *)
  let result = Math.sub 3 1 in
  print_endline (Int.to_string result) (* ans: 2 *)
```

## Execute Your Code

```sh
dune exec -w {project_name}
```

Ocaml is a compiled language, which means that it has 2 execution steps:
1. buid
2. exec

With the previous command you run both steps at the same time, as you will imagine `-w` means watch mode.

*Note:*
- As a result of the build process **dune** creates the `_build` folder, it contains Ocaml's compiler artifacts


## Create `.mli` File

By default all your Ocaml expressions in `math.ml` are shared with the `main.ml`, sometimes you would want to expose just some. For this
it's helpfull create Ocaml's intercafe file (`.mli`) where you define your Ocaml's module types.


```ml
(* lib/math.mli *)
val add : int -> int -> int
(** [add x y] returns the result of x + y. *)
```

Now you would see an error because sub is no longer accessible, let add its definition:

```ml
(* lib/math.mli *)
val add : int -> int -> int
(** [add x y] returns the result of x + y. *)

val sub : int -> int -> int
(** [sub x y] returns the result of x - y. *)
```