# Practical OCaml

![One article to rule them all](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png)

<meta property="og:image" content="https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png">
<meta property="og:title" content="An Article to Rule Them All">
<meta property="og:description" content="Exploring OCaml in depth">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png">

This is the second part of `Basic OCaml`, in this chapter we are going to write practical OCaml code! I'll be covering the features and concepts to make this possible in an easy-to-follow way. Each new topic builds upon the previous ones, ensuring a smooth learning experience.

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

- Tail Recursion Optimization
- Recursive and Parameterized Variants
- Handling Errors
  - Option Type
  - Result Type
  - Exceptions

---

# Tail Recursion Optimization

**Tail Recursion** is an optimization technique where a function call is the last action in a function. This allows the compiler to reuse the current function's stack frame for the next function call, preventing stack overflow and improving performance.

Steps to Apply Tail Recursion:

1. Identify the Base Case and Recursive Case: Determine the condition under which the recursion should stop (base case) and the part of the function that makes the recursive call (recursive case).
2. Introduce an Accumulator: Add an additional parameter to the function, known as an accumulator, which will store the intermediate results of the computation.
3. Modify the Recursive Call: Change the recursive call so that it passes the accumulator as an argument, and ensure that the recursive call is the last operation in the function.
4. Update the Base Case: Modify the base case to return the accumulator instead of performing additional computation.

**Example: Factorial Function**  
Let's convert a non-tail-recursive factorial function into a tail-recursive one.

Non-Tail-Recursive Version:

```ml
let rec factorial n =
  if n = 0 then 1
  else n * factorial (n - 1)            (* multiplication is the last operation, so it's not tail recursive *)
```

Tail-Recursive Version:

```ml
let rec factorial_tail n acc =
  if n = 0 then acc
  else factorial_tail (n - 1) (acc * n) (* the factorial_tail call is the last operation, so it's tail recursive *)

let factorial n = factorial_tail n 1;;
```

**Explanation:**

- _Accumulator_: `acc` is introduced to store the intermediate result of the `factorial` computation.
- _Recursive Call_: The recursive call `factorial_tail (n - 1) (acc * n)` is the last operation in the function, making it tail-recursive.
- _Base Case:_ When `n = 0`, the function returns the accumulator acc, which contains the final result.

**Side Note**
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

In OCaml it's possible to create recursive variants that allow us to create more complex data structures, let create for example our own version of lists:

```ml
type intList =
  | Nil
  | Cons of int * intList;;

(* type intList = Nil | Cons of int * intList *)

Cons (1, Cons (2, Cons (3, Nil)));;
(* : intList = Cons (1, Cons (2, Cons (3, Nil))) *)
```

As you can see `intList` is recursive allowing to create recursive data structures, in this case a list of integers. Let's see another example, let's create this time a list of strings:

```ml
type stringList =
  | Nil
  | Cons of string * stringList;;

(* type stringList = Nil | Cons of string * stringList *)

Cons ("hola", Cons ("mundo", Nil));;
(* : stringList = ("hola", Cons ("mundo", Nil)) *)
```

If later on we should provide our own definitions for more types, instead of creating a new variant for each type of list, it would be better to use polimorphism to parameterize any kind of list at once:

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

To do that we add the `'a` **type variable** in front on the type name as `'a customList` and we add it wherever it's needed: `'a` **\* 'a customList**

Another improvement is to generalize any kind of subsequent operation instead of creating one for every type of list:

```ml
let length lst =
  let rec length_tail acc = function
    | Nil -> acc
    | Cons (_, t) -> length_tail (acc + 1) t
  in
    length_tail 0 lst;;

(* val length : 'a customList -> int = <fun> *)

length @@ int_list;;
(* : int = 3 *)

length @@ string_list;;
(* : int = 2 *)
```

We call this type of variant parametric because it adapts to its changable parts, and we say that `length` is parametric with respect of the type of the list.

In fact, this is the way lists are defined in OCaml's standard library:

```ml
type 'a list =
  | []
  | (::) of 'a * 'a list;;
```

Lists in OCaml are recursive parameterized variants .

---

# Handling Errors

Errors are better handled as values instead of treating certain values as errors.

- The program flow is not interrupted, it's redirected
- Avoid side effects because functions remains pure
- You can handle values not errors making robust solutions
- Avoid null pointer exceptions
- Separates business logic from error handling

There are 3 ways to handle errors in OCaml:

- Option values
- Result values
- Exceptions

---

## Option Type

The option type represents a value that may or may not be present. It is a way to handle the absence of a value in a type-safe manner, avoiding the need for special sentinel values or null pointers.

### What is the Option Type?

The option type is a **_parametric variant_** that can have one of two forms:

- `Some` value: Represents the presence of a value of any type.
- `None`: Represents the absence of a value.

### Definition

```ml
type 'a option =
  | Some of 'a
  | None
```

- `'a`: This is a type variable, meaning option can be used with any type.
- `Some` value: Indicates that a value is present.
- `None`: Indicates that no value is present.

### Usage

The **option type** is useful when a function might not return a valid result.

**Example:**  
Prevent division by 0

- `x` and `y` are integers and we need to handle what happen when `y` is 0

```ml
let safe_divide x y =
  if y = 0 then None
  else Some (x / y);;

(* val safe_divide : int -> int -> int option = <fun> *)

safe_divide 3 0;;
(* : int option = None *)
```

**Example:**  
Prevent find an element in an empty list

```ml
let rec find_element element = function
  | [] -> None
  | h :: t -> if element = h then Some h else find_element element t;;

(* val find_element : 'a -> 'a list -> 'a option = <fun> *)

find_element 3 [1; 2; 4];;
(* : int option = None *)
```

**In summary**: you are explicitly telling your functions what to do in case of an undesirable input without crashing the program.

---

## Result Type

Represent computation that can succeed with a value or fail with an error. It's similar to the Option type but it provides more information in case of error.

### What is the Result Type?

The result type is also a **_parametric variant_** that can have one of two forms:

- `Ok` value: Represents the successful computation with a value.
- `Error` value: Represents a failed computation with an **error value**.

### Definition

```ml
type ('a, 'b) result =
  | Ok of 'a
  | Error of 'b
```

### Usage

The result type is useful when you need to produce especific kind of errors and capture and handle them explicitly, making error handling more robust.

**Example:**  
Instead of preventing division by 0, it throws an error value indicating that an error occurred.

```ml
let safe_divide x y =
  if y = 0 then Error "division by 0"
  else Ok (x / y);;

(* val save_divide : int -> int -> (int, string) result = <fun> *)

safe_divide 3 0;;
(* : (int, string) result = Error "division by 0" *)
```

**Example:**  
Throws an error value when trying to get the first element in an empty list

```ml
let first_element = function
  | [] -> Error "Empty list"
  | h :: t -> Ok h;;

(* val first_element : 'a list -> ('a, string) result = <fun> *)

first_element [];;
(* : ('a, string) result = Error "Empty list" *)
```

---

## Exceptions

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

## Accessig Array Elements

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

Applies a given function to each element of a Array for side effects, such as printing.  
Usage: `Array.iter func Array`

```ml
Array.iter (fun x -> Printf.printf "%d " x) [|1; 2; 3; 4|];;
(*  1 2 3 4 : unit = () *)
```

**Array.fold_left** and **Array.fold_right**

Fold functions that reduce a Array to a single value using a binary function.  
Usage: `Array.fold_left func acc array`

```ml
Array.fold_left (fun acc x -> acc + x) 0 [|1; 2; 3; 4|];;
(* : int = 10 *)
```
