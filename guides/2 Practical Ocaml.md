# Practical OCaml

<!-- ![One Article to Rule Them All](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png)

<meta property="og:image" content="https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png">
<meta property="og:title" content="An Article to Rule Them All">
<meta property="og:description" content="Exploring OCaml in depth">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png"> -->

Welcome to the second part of `Basic OCaml`, where we dive into writing practical OCaml code! This tutorial builds upon the foundational concepts introduced earlier, ensuring a smooth and comprehensive learning experience. Each topic is presented in an easy-to-follow manner, with new concepts building upon previous ones.

This tutorial is based on my notes from Professor Michael Ryan Clarkson’s excellent course, along with insights from OCaml’s official manual and documentation. A huge thank you to Professor Michael for his incredible teaching and to Sabine for creating such clear and comprehensive documentation! 🫰

## References

- [OCaml Programming: Correct + Efficient + Beautiful](https://www.youtube.com/watch?v=MUcka_SvhLw&list=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU)
- [OCaml Manual](https://ocaml.org/manual/5.3/index.html)
- [OCaml Docs/Values and Functions](https://ocaml.org/docs/values-and-functions)
- [OCaml Docs/Basic Data Types](https://ocaml.org/docs/basic-data-types)
- [The OCaml API](https://ocaml.org/manual/5.3/api)

Happy reading! 🚀

---

# Index

- [Tail Recursion Optimization](#tail-recursion-optimization)
- [Recursive and Parameterized Variants](#recursive-and-parameterized-variants)
- [Handling Errors](#handling-errors)
  - [Option Type](#option-type)
  - [Result Type](#result-type)
  - [Exceptions](#exceptions)
- [Mutations in OCaml](#mutations-in-ocaml)
  - [References (Refs)](#references-refs)
  - [Aliasing](#aliasing)
  - [Equality](#equality)
  - [Sequence Operator (`;`)](#sequence-operator-)
  - [Mutable Record Fields](#mutable-record-fields)
- [Arrays](#arrays)

---

# Tail Recursion Optimization

**Tail Recursion** is an optimization technique where a function call is the last action in a function. This allows the compiler to reuse the current function's stack frame for the next function call, preventing stack overflow and improving performance.

### Steps to Apply Tail Recursion:

1. **Identify the Base Case and Recursive Case**: Determine the condition under which the recursion should stop (base case) and the part of the function that makes the recursive call (recursive case).
2. **Introduce an Accumulator**: Add an additional parameter to the function, known as an accumulator, which will store the intermediate results of the computation.
3. **Modify the Recursive Call**: Change the recursive call so that it passes the accumulator as an argument, and ensure that the recursive call is the last operation in the function.
4. **Update the Base Case**: Modify the base case to return the accumulator instead of performing additional computation.

### Example: Factorial Function

Let's convert a non-tail-recursive factorial function into a tail-recursive one.

#### Non-Tail-Recursive Version:

```ml
let rec factorial n =
  if n = 0 then 1
  else n * factorial (n - 1)  (* Multiplication is the last operation, so it's not tail recursive *)
```

#### Tail-Recursive Version:

```ml
let rec factorial_tail n acc =
  if n = 0 then acc
  else factorial_tail (n - 1) (acc * n)  (* The factorial_tail call is the last operation, so it's tail recursive *)

let factorial n = factorial_tail n 1;;
```

#### Explanation:

- **Accumulator**: `acc` is introduced to store the intermediate result of the `factorial` computation.
- **Recursive Call**: The recursive call `factorial_tail (n - 1) (acc * n)` is the last operation in the function, making it tail-recursive.
- **Base Case**: When `n = 0`, the function returns the accumulator `acc`, which contains the final result.

#### Alternative Syntax:

A common way to write this in OCaml is:

```ml
let factorial n =
  let rec factorial_tail n acc =
    if n = 0 then acc
    else factorial_tail (n - 1) (acc * n)
  in
  factorial_tail n 1;;
```

---

# Recursive and Parameterized Variants

In OCaml, you can create recursive variants to build more complex data structures. Let's create our own version of lists:

```ml
type intList =
  | Nil
  | Cons of int * intList;;

(* type intList = Nil | Cons of int * intList *)

Cons (1, Cons (2, Cons (3, Nil)));;
(* : intList = Cons (1, Cons (2, Cons (3, Nil))) *)
```

As you can see, `intList` is recursive, allowing the creation of recursive data structures, such as a list of integers. Let's see another example, this time creating a list of strings:

```ml
type stringList =
  | Nil
  | Cons of string * stringList;;

(* type stringList = Nil | Cons of string * stringList *)

Cons ("hola", Cons ("mundo", Nil));;
(* : stringList = ("hola", Cons ("mundo", Nil)) *)
```

To avoid creating a new variant for each type of list, we can use polymorphism to parameterize any kind of list:

```ml
type 'a customList =
  | Nil
  | Cons of 'a * 'a customList;;

(* type 'a customList = Nil | Cons of 'a * 'a customList *)

let int_list = Cons (1, Cons (2, Cons (3, Nil)));;
(* val int_list : int customList = Cons (1, Cons (2, Cons (3, Nil))) *)

let string_list = Cons ("hola", Cons ("mundo", Nil));;
(* val string_list : string customList = Cons ("hola", Cons ("mundo", Nil)) *)
```

To achieve this, we add the `'a` **type variable** in front of the type name as `'a customList` and use it wherever needed: `'a * 'a customList`.

We can also generalize subsequent operations for any type of list:

```ml
let length lst =
  let rec length_tail acc = function
    | Nil -> acc
    | Cons (_, t) -> length_tail (acc + 1) t
  in
  length_tail 0 lst;;

(* val length : 'a customList -> int = <fun> *)

length int_list;;
(* : int = 3 *)

length string_list;;
(* : int = 2 *)
```

This type of variant is called parametric because it adapts to its changeable parts. The `length` function is parametric with respect to the type of the list.

In fact, this is how lists are defined in OCaml's standard library:

```ml
type 'a list =
  | []
  | (::) of 'a * 'a list;;
```

Lists in OCaml are recursive parameterized variants.

---

# Error Handling

Errors are better handled as values instead of treating certain values as errors. This approach offers several advantages:

- The program flow is not interrupted; it's redirected.
- Functions remain pure, avoiding side effects.
- You can handle values, not errors, making solutions more robust.
- Null pointer exceptions are avoided.
- Business logic is separated from error handling.

There are three ways to handle errors in OCaml:

- Option values
- Result values
- Exceptions

---

## Option Type

The option type represents a value that may or may not be present. It handles the absence of a value in a type-safe manner, avoiding the need for special sentinel values or null pointers.

### Definition

The option type is a parametric variant that can have one of two forms:

```ml
type 'a option =
  | Some of 'a
  | None
```

- `'a`: This is a type variable, meaning option can be used with any type.
- `Some`: Indicates that a value is present.
- `None`: Indicates that no value is present.

### Usage

The **option type** is useful when a function might not return a valid result.

#### Example: Prevent Finding an Element in an Empty List

```ml
let rec find_element el = function
  | [] -> None
  | h :: t -> if el = h then Some h else find_element el t;;

(* val find_element : 'a -> 'a list -> 'a option = <fun> *)

find_element 3 [1; 2; 4];;
(* : int option = None *)
```

#### Summary:

You are explicitly telling your functions what to do in case of an undesirable input without crashing the program.

---

## Result Type

The result type represents a computation that can succeed with a value or fail with an error. It is similar to the option type but provides more information in case of an error.

### Definition

The result type is also a **parametric variant** that can have one of two forms:

```ml
type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b
```

- `Ok` value: Represents a successful computation with a value.
- `Error` value: Represents a failed computation with an **error value**.

### Usage

The result type is useful when you need to produce specific kinds of errors, making error handling more robust.

#### Example: Throwing an Error Value When Trying to Get the First Element in an Empty List

```ml
let first_element = function
  | [] -> Error "Empty list"
  | h :: t -> Ok h;;

(* val first_element : 'a list -> ('a, string) result = <fun> *)

first_element [];;
(* : ('a, string) result = Error "Empty list" *)
```

#### Example: Throwing an Error Value for Division by Zero

```ml
let safe_divide x y =
  if y = 0 then Error "division by 0"
  else Ok (x / y);;

(* val safe_divide : int -> int -> (int, string) result = <fun> *)

safe_divide 3 0;;
(* : (int, string) result = Error "division by 0" *)
```

#### Summary:

You are explicitly telling your functions what to do in case of an error without crashing the program.

---

## Exceptions

### Definition

Exceptions (`exn`) are a special type of variants called **extensible variants**. You can add constructors later on with the `exception` keyword:

```ocaml
exception SomethingHappened of string
```

- `SomethingHappened` is a new constructor added to the type `exn`.

### Raising an Exception

To raise an exception, call the `raise` function with a value from the constructor as an argument:

```ocaml
raise @@ SomethingHappened "Something went wrong"
```

Note that `raise` never returns a value; it interrupts the normal flow of the program and must be caught.

### Catching Exceptions

The `try ... with` construct provides a clean separation for handling exceptions, allowing you to separate the "happy path" code from error-handling logic. Here's a general structure:

```ocaml
let safe_operation () =
  try
    Ok (some_risky_function ())
  with
    | EmptyList -> Error "Got an empty list"
    | Invalid_argument msg -> Error ("Invalid argument: " ^ msg)
    | _ -> Error "Unknown error occurred"  (** Catch-all pattern **)
```

> **Note**: You can match specific exceptions and respond accordingly, or use `_` to catch any unhandled exceptions.

#### Concrete Example: Safe Division

Let's say we want to divide two floats but avoid division by zero:

```ocaml
let div x y =
  if y = 0. then
    raise (Invalid_argument "Division by 0")
  else
    x /. y
;;
(* val div : float -> float -> float = <fun> *)
```

We can wrap it safely like this:

```ocaml
let safe_div x y =
  try
    Ok (div x y)
  with
    | Invalid_argument msg -> Error ("Invalid argument: " ^ msg)
    | _ -> Error "Unknown error occurred"
;;
(* val safe_div : float -> float -> (float, string) result = <fun> *)
```

So anytime `y` takes a value of `0`, an `Invalid_argument` error is raised:

```ocaml
safe_div 3. 1.;;
(* : (float, string) result = Ok 3. *)

safe_div 3. 0.;;
(* : (float, string) result = Error "Invalid argument: Division by 0" *)
```

#### Extracting the Value:

If you need the value, you can use the built-in `Result` module to help you and pass a default value in case an error occurs:

```ml
let value = Result.value (safe_div 10. 0.) ~default:0.;;
```

> **Note**: By building programs with errors in mind, we naturally create more robust software. It’s a form of testing as we code—we anticipate possible failures and plan how to handle them gracefully.

---

# Mutations in OCaml

Sometimes side effects are necessary. Let's see how OCaml handles them:

## References (Refs)

A reference is a pointer to a typed location in memory.

- The binding to a pointer is: **immutable**.
- The content of the memory location is: **mutable**.

### Usage

Let's see the most basic operations you can do with references:

```ml
let value = ref 123;;  (** Create a new ref **)
(* val value : int ref = {contents = 123} *)

value := 321;;  (** Change the content **)
(* : unit = () *)

!value;;  (** Extract the content **)
(* : int = 321 *)

value := "mi piace la pizza!";;  (** Trying to change the content's type **)
(* Error: This constant has type string but an expression was expected of type int *)
```

- The `ref` keyword creates a new reference.
- The `:=` operator assigns a new content to the reference.
- The `!` (bang) operator extracts the content of the reference.

> **Notice**: Once defined, you can't change the type of a reference, so the last operation throws an error.

---

## Aliasing

Aliasing occurs when two or more references point to the same location in memory.

#### Example:

```ml
let age = ref 32
let my_age = age;;  (** aliases **)
```

Both `age` and `my_age` point to the same location in memory. As a result, changing the content of `age` also changes `my_age`:

```ml
age := 34;;

!my_age;;
(* : int = 34 *)
```

---

## Equality

Now you are prepared to understand the distinction between physical and structural equality:

### Physical Equality

Evaluates the same location in memory:

```ml
let r1 = ref 123
let r2 = ref 123;;

(** Evaluates the same location in memory **)
r1 == r1;;
(* : bool = true *)

r1 != r2;;
(* : bool = true *)
```

It uses the `==` and `!=` operators.

### Structural Equality

Evaluates the same content in memory:

```ml
let r1 = ref 123
let r2 = ref 123;;

(** Evaluates the same content in memory **)
r1 = r1;;
(* : bool = true *)

r1 = r2;;
(* : bool = true *)

ref 123 <> ref 321;;
(* : bool = true *)
```

It uses the `=` and `<>` operators.

---

## Sequence Operator (`;`)

The sequence operator allows you to execute multiple expressions in sequence, returning the value of the last expression.

```ml
expression1 ; expression2 ; expression3
```

In this sequence, all expressions are evaluated in order, but only the value of the last expression (`expression3`) is returned as the result of the entire sequence.

#### Example:

```ml
let result =
  print_string "Hello, ";
  print_string "OCaml!";
  42
;;
```

This evaluates to:

- Prints "Hello, OCaml!" to the console.
- Returns the integer value `42`.

### Usage

**Side Effects**: Since only the last value is returned and the previous values are discarded, their sole purpose is to produce side effects.

#### Counter Example

```ml
let counter = ref 0

let next = fun () ->
  counter := !counter + 1;
  !counter
;;
```

Or its syntactic sugar version:

```ml
let next () =
  incr counter;
  !counter
;;
```

```ml
next();;
(* : int = 1 *)

next();;
(* : int = 2 *)
```

Writing side effects in OCaml is beautiful. It uses special syntax that makes it expressive, helping you be conscious of possible side effects whenever you see them.

Bear in mind that this is not the only way to build a counter in OCaml. It can also be created through a closure:

```ml
let next =
  let counter = ref 0 in
  fun () ->
    incr counter;
    !counter
;;
```

---

## Mutable Record Fields

```ml
type point = { x : float; y : float; mutable color : string }

let p1 = { x = 1.; y = 2.; color = "blue" };;
(* val p1 : point = { x = 1.; y = 2.; color = "blue" } *)
```

```ml
p1.color <- "red";;
(* : unit = () *)

p1;;
(* : point = {x = 1.; y = 2.; color = "red"} *)
```

This is possible because we declared `color` as a **mutable** field.

```ml
p1.x <- 0.;;
(* Error: The record field x is not mutable *)
```

The `<-` operator is used to mutate fields.

References in OCaml are essentially implemented as records with mutable fields:

```ml
type 'a ref = { mutable contents : 'a }
let ref x = { contents = x }  (* Returns a record with a mutable value *)

let (!) r = r.contents  (* Receives a record and returns its 'contents' field *)
let (:=) r newval = r.contents <- newval  (* Updates the mutable field 'contents' *)
```

---

# Arrays

Arrays provide a way to store a fixed-size collection of elements of the same type, allowing for efficient random access and updates. Unlike lists, arrays are mutable, meaning you can change the value of an element after the array has been created.

```ml
let numbers = [|1; 2; 3; 4; 5|];;
(* val numbers : int array = [|1; 2; 3; 4; 5|] *)
```

## Creating Arrays

```ml
let zeros = Array.make 5 0  (* zeros is [|0; 0; 0; 0; 0|] *)
```

```ml
let squares = Array.init 5 (fun i -> i * i)  (* squares is [|0; 1; 4; 9; 16|] *)
```

## Accessing Array Elements

```ml
let first_element = numbers.(0)  (* first_element is 1 *)
```

## Modifying Array Elements

```ml
numbers.(0) <- 10;
(* numbers is now [|10; 2; 3; 4; 5|] *)
```

## Array Functions

**Array.length**

Returns the length of a given array.
Usage: `Array.length array`

```ml
Array.length [|1; 2; 3|];;
(* : int = 3 *)
```

**Array.map**

Applies a function to each element of an array and returns a new array with the results.
Usage: `Array.map function array`

```ml
Array.map (fun x -> x * 2) [|1; 2; 3|];;
(* : int array = [|2; 4; 6|] *)
```

**Array.iter**

Applies a given function to each element of an array for side effects, such as printing.
Usage: `Array.iter func array`

```ml
Array.iter (fun x -> Printf.printf "%d " x) [|1; 2; 3; 4|];;
(*  1 2 3 4 : unit = () *)
```

**Array.fold_left** and **Array.fold_right**

Fold functions that reduce an array to a single value using a binary function.
Usage: `Array.fold_left func acc array`

```ml
Array.fold_left (fun acc x -> acc + x) 0 [|1; 2; 3; 4|];;
(* : int = 10 *)
```
