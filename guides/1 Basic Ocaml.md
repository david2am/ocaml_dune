# Basic OCaml

![One article to rule them all](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png)

<meta property="og:image" content="https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png">
<meta property="og:title" content="An Article to Rule Them All">
<meta property="og:description" content="Exploring OCaml in depth">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="https://dev-to-uploads.s3.amazonaws.com/uploads/articles/tx64r92ywj5o1mwg9k39.png">

Welcome to this beginner-friendly OCaml tutorial! My goal is to make this your ultimate introduction to the language, covering all the fundamental concepts in a structured, easy-to-follow way. Each new topic builds upon the previous ones, ensuring a smooth learning experience.

This tutorial is based on my notes from Professor Michael Ryan Clarkson’s excellent course, along with insights from OCaml’s official manual and documentation. A huge thank you to Professor Michael for his incredible teaching and to Sabine for creating such clear and comprehensive documentation! 🫰

## References

- [OCaml Programming: Correct + Efficient + Beautiful](https://www.youtube.com/watch?v=MUcka_SvhLw&list=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU)
- [Byjus](https://byjus.com/maths/recursive-function)
- [OCaml Manual](https://ocaml.org/manual/5.3/index.html)
- [OCaml Docs/Values and Functions](https://ocaml.org/docs/values-and-functions)
- [OCaml Docs/Basic Data Types](https://ocaml.org/docs/basic-data-types)
- [The OCaml API](https://ocaml.org/manual/5.3/api)

Happy reading! 🚀

---

# Index

- Utop
- SECTION 1: EXPRESSIONS AND DEFINITIONS
  - Values
  - If Expressions
  - `unit` Type
  - `let` Definitions
  - `let` Expressions
  - Anonymous Functions
  - Named Functions
  - High-Order Functions
  - Recursive Functions
  - Operators As Functions
- SECTION 2: COMMON DATA STRUCTURES AND OPERATIONS
  - Lists
  - Tuples
  - Records
- SECTION 3: DIGGING IN OCAML
  - Lexical Scope
  - Parametric Polymorphism
  - Variants
  - Pattern Matching

---

# Utop

To follow this tutorial, you can use **Utop**, OCaml's REPL (recommended), or **Dune**. Here, I'll explain how to configure Utop:

1. Ensure you have OCaml and its associated tools installed (refer to the guide `/2. Ocaml in Dune.md`).
2. Open a new terminal.
3. Run the command `utop` to start the interactive OCaml toplevel.

Additionally:

- To evaluate an expression in **Utop**, end each expression with `;;` and then press `Enter`.
- To exit, execute the command `#quit;;`.

---

# SECTION 1: EXPRESSIONS AND DEFINITIONS

In OCaml, expressions are code constructs that evaluate to a value without altering the program's state. Definitions introduce names and associate them with values, behaviors, types, or modules, known as **bindings**.

## Values

A value is an expression that doesn't need further evaluation. Let's explore some examples in OCaml:

### Integers

```ml
1;;
(* : int = 1 *)

1 + 4;;
(* : int = 5 *)

Int.to_string 14;;
(* : string = "14" *)

Int.max 3 7;;
(* : int = 7 *)
```

### Booleans

```ml
false;;
(* : bool = false *)

3 > 2;;
(* : bool = true *)

Bool.to_string true;;
(* : string = "true" *)
```

### Chars

```ml
'd';;
(* : char = 'd' *)
```

### Strings

```ml
"hola!";;
(* : string = "hola" *)

"hola" ^ " mundo!";;
(* : string = "hola mundo!" *)

"hola".[2];;
(* : char = 'l' *)

String.length "hola mundo!";;
(* : int = 11 *)

String.uppercase_ascii "hola mundo!";;
(* : string = "HOLA MUNDO!" *)
```

### Floats

```ml
1.0;;
(* : float = 1.0 *)

1.0 +. 4.0;;
(* : float = 5.0 *)

Float.of_string "14";;
(* : float = 14. *)

Float.round 6.2;;
(* : float = 6. *)
```

OCaml distinguishes between integer and float operators, which helps the language infer type definitions directly from used operators. For example:

- `2.5 *. 5.` is valid.
- `7.5 +. 3` is invalid because the operator `+.` requires both numbers to be of type float.

---

**Note:**  
OCaml includes built-in modules for common operations, such as `Float.round` and `String.length`. For more information, visit [The OCaml API](https://ocaml.org/manual/5.3/api/index.html).

---

## If Expressions

**If expressions** conditionally evaluate one branch over another. In OCaml, **if expressions** always return a value because their branches are expressions, and the **else clause** is mandatory.

```ml
if condition then ifBranch else elseBranch;;
(* if condition is true then returns ifBranch *)
(* if condition is false then returns elseBranch *)

if "pineapple pizza" > "pizza margherita" then "Non sei italiano" else "Tu sei un vero italiano";;
(* : string = "Tu sei un vero italiano" *)
```

### Particularities

- **condition expression** should evaluate to boolean.
- Both branch expressions should have the same type.
- **else branch** is required.

```ml
if 0 then "Non sei italiano" else "Tu sei un vero italiano";;
(* Error: value 0 is not a boolean expression *)

if true then "Non sei italiano" else 1;;
(* Error: "Non sei italiano" and 1 have different types *)

if true then "Non sei italiano";;
(* Error: else branch is not provided *)
```

---

## `unit` Type

The `unit` type is equivalent to `void` in other programming languages but is a valid type in OCaml. It has only one possible value, denoted by `()`.

```ml
print_endline "Hello, world!";;
(* Hello, world! *)
(* : unit = () *)
```

---

## `let` Definitions

`let` definitions are bindings that are always immutable.

```ml
let greet = "Ciao!";;
(* val greet : string = "Ciao!" *)
```

**Note:**  
The `utop` response indicates that `"Ciao!"` is a `string` bound to a **value definition** called `greet` (it's readed from right to left).

### `let` Definitions Are Immutable

```ml
let pi = 3.1;;
(* val pi : float = 3.1 *)

pi = 3.1415;;
(* : bool = false *)

let pi = 3.1415;;
(* val pi : float = 3.1415 *)
```

- The result of `pi = 3.1` may seem strange but satisfies immutability:
  - you can't mutate a `let` definition
  - In OCaml, `=` is the boolean comparison operator.
- `let pi = 3.1415` creates a new memory allocation with the same name `pi`, so it's not a mutation but a re-definition.

---

## `let` Expressions

Let expressions allow you to bind subexpressions within a larger expression using a name. In OCaml, the `in` keyword indicates that the preceding is a subexpression that can be used in subsequent expressions.

This concept is similar to mathematical substitution, where you replace variables with their values:

```ml
let x = 7 in 3 + x;;
(* : int = 10 *)

(*
   You can think of this as a kind of mathematical substitution:

   let x = 7

   in: 3 + x
   is: 3 + 7
   resolves to: 10
 *)
```

Let expressions can be used with any type of value, not just integers. For example:

```ml
let greet = "salve" in greet ^ " mondo!";;
(* val greet : string = "salve mondo!" *)
```

### `let` Expression Scope

Scope refers to the region of a program where a binding is meaningful and can be accessed. In other words, it's where you can substitute a binding with its value.

Let's revisit an example with a fresh perspective:

```ml
let x = 7 in let y = 3 in x + y;;
                         <- A ->
             <------- B ------->
<-------------- C ------------->
(* Where A is a subexpression of B, and B a subexpression of a bigger expression C *)
```

In this example:

- `x` is meaningful within subexpression B, but not before.
- Similarly, `y` is meaningful within subexpression A, but not before.

As OCaml follows **lexical scoping** rules, the most recent definition of a binding takes precedence:

```ml
let x = 10 in let x = 5 in x ;;
(* : int = 5 *)
```

---

**Note:**  
More into scoping is the `Lexical Scope` section of this article.

---

## Anonymous Functions

Anonymous functions, also known as **lambda functions**, are expressions that contain behavior. They are particularly useful for creating short, one-off functions that are often passed as arguments to higher-order functions. In OCaml, anonymous functions are defined using the `fun` keyword:

```ml
fun x -> x + 10;;
(* : int -> int = <fun> *)
```

- This anonymous function takes an integer `x` and returns `x + 10`.
- The type signature `int -> int` indicates that the function takes an integer as input and returns an integer.

Now let's pass an argument to the function:

```ml
(fun x -> x + 10) 35;;
(* : int = 45 *)
```

- In OCaml, you do not need to use parentheses to invoke a function.
- Here, `35` is passed to the anonymous function, resulting in `45`.

Additionally, `let` expressions can be seen as syntactic sugar for function applications:

```ml
(* Both expressions are equivalent: *)
let x = 35 in x + 10;;
(fun x -> x + 10) 35;;
```

- The `let` expression binds `x` to `35` and then evaluates `x + 10`.
- The anonymous function does the same by directly applying `35` to the function body.

---

## Named Functions

In OCaml, anonymous functions are values, and using the `let` keyword, you can create a binding:

```ml
let sum_10 = fun x -> x + 10
(* val sum_10 : int -> int = <fun>  *)
```

Alternatively, you can use a more concise syntax by placing the arguments on the left side of the equal sign and omitting the `fun` and `->` keywords:

```ml
let sum_10 x = x + 10
(* val sum_10 : int -> int = <fun>  *)
```

- This syntax achieves the same result but is more concise and readable.

---

## High-Order Functions

High-order functions are functions that take other functions as arguments or return them as results. They are a fundamental concept in functional programming and allow for greater abstraction and code reuse.

The List.map function is a classic example of a high-order function. It applies a given function to each element of a list and returns a new list with the results.

```ml
let increment x = x + 1;;

List.map increment [1; 2; 3; 4];;
(* : int list = [2; 3; 4; 5] *)
```

**Explanation:**

- List.map takes two arguments: a function (increment) and a list ([1; 2; 3; 4]).
- It applies the increment function to each element of the list, returning a new list with the incremented values.

High-order functions enable you to write more modular and reusable code by abstracting common patterns of computation.

### Closures

Closures refer to the ability of a function to capture and "remember" the environment in which it was created. This means that a function can access variables from its surrounding scope, even after that scope has finished executing.

**Example: Multiplier Function**

```ml
let make_multiplier factor =
  fun x -> x * factor

let double = make_multiplier 2
let triple = make_multiplier 3

double 5;;
(* : int = 10 *)

triple 5;;
(* : int = 15 *)
```

**Explanation:**

- `make_multiplier` is a function that takes a factor and returns another function.
- The returned function is a closure that captures the factor from its surrounding scope.
- `double` and `triple` are instances of this closure, each capturing a different value for factor.
- When you call `double 5`, it multiplies 5 by 2 (the captured factor), resulting in 10.
- Similarly, `triple 5` multiplies 5 by 3, resulting in 15.

---

### Partial Applications

In OCaml, functions that take multiple arguments do not use commas to separate the arguments. Instead, arguments are separated by spaces, and functions that seem to take multiple arguments are actually several nested functions that take one argument at a time. This is called "currying."

```ml
fun x y -> x + y;;
(* : int -> int -> int = <fun> *)

(* is syntactic sugar of: *)
fun x -> (fun y -> x + y);;
(* : int -> int -> int = <fun> *)
```

This is evident in their type definition: `: int -> int -> int`, which is essentially a function that returns another function `: int -> (int -> int)`.

**Creating Specialized Functions**  
You can use partial application to create specialized functions. For example, you can create a function `add_4` that always adds 4 to any number:

```ml
let add x y = x + y;;
(* val add : int -> int -> int = <fun> *)

let add_4 = add 4;;
(* val add_4 : int -> int = <fun> *)

add_4 8;;
(* : int = 12 *)

add_4 10;;
(* : int = 14 *)
```

- The function `add` takes two integers, `x` and `y`, and returns their sum.
- The type signature `int -> int -> int` indicates that `add` is a function that takes an integer and returns another function that takes an integer and returns an integer.
- By partially applying the `add` function with the argument `4`, you create a new function `add_4` that only requires one argument, simplifying its usage.

---

## Recursive Functions

Imagine climbing a staircase from the ground floor to the first floor. You take each step one at a time. To reach the second step, you must first step onto the first. Similarly, to reach the third step, you must first be on the second step. Each step forward builds on the previous steps, creating a repeated sequence with a consistent pattern between each step. This concept illustrates recursion, where a problem is solved by breaking it down into smaller, similar sub-problems.

(Example inspired by [Byjus](https://byjus.com/maths/recursive-function)).

```ml
                       o
                      /|\
                ___ 4 / \
            ___| 3
        ___| 2
    ___| 1
___| ground

Step 2 = Step 1 + ground floor

Step 3 = Step 2 + step 1 + ground floor

And so on.
```

Functional programming prefers recursive functions over loops because they can be pure functions that call themselves without producing side effects, or at least producing only **external side effects**.

A recursive function has two parts:

- **Base Case**: Defines the simplest version of the problem, which stops the recursion.
- **Recursive Case**: Defines the nth term, how the function calls itself with a smaller input, progressively reducing the problem toward the base case.

**Example**
In OCaml, you must explicitly use the `rec` keyword when defining a recursive function:

```ml
let rec factorial n =
  if n = 0 then 1 (* base case *)
  else n * factorial (n - 1);; (* recursive case *)
(* val factorial : int -> int = <fun> *)
```

**Breakdown:**

- **Base Case**: The function stops when `n = 0`, returning `1`. This prevents infinite recursion.
- **Recursive Case**: The function calls itself with `n - 1`, reducing the problem step by step until it reaches the base case.

---

## Operators As Functions

In OCaml, operators are essentially functions. This means you can use them in the same way you use any other function, allowing for greater flexibility in your code. There are two primary ways to use operators:

1. **Infix Notation**: This is the typical way operators are used, where the operator is placed between the operands.

   ```ml
   1 + 5;;
   (* : int = 6 *)
   ```

2. **Prefix Notation**: By enclosing the operator in parentheses, you can use it as a function, passing the operands as arguments.

   ```ml
   ( + ) 1 5;;
   (* : int = 6 *)
   ```

**Benefits of Using Operators as Functions**

- **Partial Application**: You can partially apply operators to create new functions.

  ```ml
  let add_five = ( + ) 5;;
  (* val add_five : int -> int = <fun> *)

  add_five 3;;
  (* : int = 8 *)
  ```

- **Consistency**: Treating operators as functions maintains a consistent functional programming style, making your code more predictable and easier to reason about.

### Application Operator

The application operator (`@@`) allows you to avoid writing parentheses, making expressions cleaner and easier to read. It is defined as follows:

```ml
let (@@) f g = f g
```

Consider the following function and expressions:

```ml
let add x y = x + y;;

add 2 5 * 4;;
(* Result: int = 28, not the desired outcome due to operator precedence *)

add 2 (5 * 4);;
(* Result: int = 22, correct but requires parentheses *)

add 2 @@ 5 * 4;;
(* Result: int = 22, using the application operator for clarity *)
```

### Reverse Application (Pipeline)

The reverse application operator, also known as the pipeline operator (`|>`), allows you to write operations from left to right in a more natural and readable manner. It is defined as follows:

```ml
let (|>) f g = g f
```

Consider the following functions and expressions:

```ml
let add x y = x + y;;
let square x = x * x;;

square (square (add 5 10));;
(* Result: int = 50625, nested function calls, read from right to left *)

5 |> add 10 |> square |> square;;
(* Result: int = 50625, using the pipeline operator for readability *)
```

---

# SECTION 2: COMMON DATA STRUCTURES AND OPERATIONS

## Lists

Lists in OCaml provide a simple and efficient way to manage sequences of elements. They are particularly well-suited for functional programming due to their immutability and support for recursive operations. Lists are especially efficient for operations that involve adding or removing elements at the beginning.

### Defining Lists

A list in OCaml is defined using square brackets, with elements separated by semicolons. Lists can contain elements of any type, but all elements in a single list must be of the same type.

```ml
[];;
(* : 'a list = [] *)

[1; 2; 3];;
(* : int list = [1; 2; 3] *)

[1.; 2.; 3.];;
(* : float list = [1.; 2.; 3.] *)

[true; false; true];;
(* : bool list = [true; false; true] *)

[[1; 2]; [3; 4]; [5; 6]];;
(* : int list list = [[1; 2]; [3; 4]; [5; 6]] *)
```

---

**Note:**

- The empty list is of type `'a list`, where `'a` is a **type variable**. It acts as a generic type that gets specialized based on the elements it contains. More of this in the `Parametric Polymorphism` section of this article.

### Cons Operator (`::`)

Appends an element in front of a list:

```ml
0 :: [1; 2; 3];;
(* : int list = [0; 1; 2; 3] *)
```

**Note:**

- `[0; 1; 2; 3]` is a new list.
- `[0; 1; 2; 3]` is syntactic sugar for `0 :: 1 :: 2 :: 3 :: []`.
- In the new list, `0` is called the **head**, and `[1; 2; 3]` is called the **tail**.

### Append Operator (`@`)

Combines two lists into one:

```ml
[0; 1] @ [2; 3];;
(* : int list = [0; 1; 2; 3] *)
```

### List Module

The List module in OCaml provides a collection of functions to work with lists. Here are some of them:

**List.map**: Applies a given function to each element of a list and returns a new list with the results.  
Usage: `List.map func list`

```ml
List.map (fun x -> x * x) [1; 2; 3; 4];;
(* : int list = [1; 4; 9; 16] *)
```

**List.mem**: Checks whether a given element is a member of a list.  
Usage: `List.mem element list`

```ml
List.mem 3 [1; 2; 3; 4];;
(* : bool = true *)
```

**List.find**: Returns the first element of a list that satisfies a given predicate. Throws a `Not_found` exception if no such element is found.  
Usage: `List.find predicate list`

```ml
List.find (fun x -> x mod 2 = 0) [1; 3; 5; 4; 6];;
(* : int = 4 *)
```

**List.filter**: Returns a new list containing only the elements that satisfy a given predicate.  
Usage: `List.filter predicate list`

```ml
List.filter (fun x -> x mod 2 = 0) [1; 2; 3; 4; 5];;
(* : int list = [2; 4] *)
```

**List.length**: Returns the length of a list.  
Usage: `List.length`

```ml
List.length [1; 2; 3];;
(* : int = 3 *)
```

**List.fold_left and List.fold_right**: Fold functions that reduce a list to a single value using a binary function.  
Usage: `List.fold_left func acc list`

```ml
List.fold_left (fun acc x -> acc + x) 0 [1; 2; 3; 4];;
(* : int = 10 *)
```

---

## Tuples

Tuples are a simple and useful way to aggregate data, which can be of different types. They are especially suitable for temporary groupings or when the order of elements is meaningful.

Here is how you can define a tuple:

```ml
let alice = ("Alice", 30, "alice@email.com");;
(* val alice : string * int * string = ("Alice", 30, "alice@email.com") *)
```

Optionally, you can specify custom reusable types for your tuples:

```ml
type person = string * int * string

let alice : person = ("Alice", 30, "alice@email.com");;
(*
   type person = string * int * string
   val alice : person = ("Alice", 30, "alice@email.com")
 *)
```

### Accessing Tuple Elements

```ml
let (name, age, email) = alice;;
(*
   val name : string = "Alice"
   val age : int = 30
   val email : string = "alice@email.com"
 *)
```

Alternatively, you can use functions like `fst` and `snd` to access the first and second elements of a pair (a 2-element tuple):

```ml
let point = (1, 3)

let x = fst point
let y = snd point;;
(*
   val point : int * int = (1, 3)
   val x : int = 1
   val y : int = 3
 *)
```

---

## Records

Records are a powerful way to group related data into a single unit with named fields. Unlike tuples, which use positional access, records allow you to access data by field names, making your code more readable and maintainable.

**Usage:**

1. Create the type definition that specifies the names and types of the fields that the record will contain.
2. Create instances of that record by specifying values for each field.

```ml
type person = {
  name : string;
  age : int;
  email : string;
}

let paolo = {
  name = "paolo";
  age = 32;
  email = "paolo@email.com";
};;
(*
   type person = { name : string; age : int; email : string; }
   val paolo : person = { name = "paolo"; age = 32; email = "paolo@email.com" }
 *)
```

**Note:**  
OCaml automatically knows that `paolo` is a `person`. You can explicitly state it, but it's not strictly necessary for records.

### Accessing Record Elements

**Direct Access**

```ml
paolo.name;;
(* : string = "paolo" *)

paolo.age;;
(* : int = 32 *)

paolo.email;;
(* : string = "paolo@email.com" *)
```

**Destructuring**

```ml
let { name; age } = paolo;;
(*
   val name : string = "paolo"
   val age : int = 32
 *)
```

---

# SECTION 3: DIGGING IN OCAML

## Lexical Scope

OCaml adheres to lexical scoping, also known as **static scoping**. This means that the scope of a variable is determined at compile time based on the structure of the code, rather than at runtime based on the execution context. Lexical scoping simplifies reasoning about code, as it eliminates the need to track the dynamic context, unlike **dynamic scoping** where the scope is resolved at runtime.

### Scope for Function Arguments

Function arguments in OCaml are local to the function and cannot be accessed outside its body. Additionally, OCaml function parameters are passed as value copies, not as references to the original arguments. This design prevents unintended modifications to the original data, enhancing both safety and predictability.

### Locality of Bindings

- Bindings defined **within a function** are local to that function and cannot be accessed outside of it.
- Bindings introduced within a `let` **expression** are local to that expression.
- Bindings defined at the **top level** (global scope) are accessible throughout the module.

### Lexical Scoping and Closure

OCaml functions can **capture bindings** from their surrounding scope, even after that scope has exited. This feature, known as a closure, allows functions to retain access to variables from their defining environment. Captured variables are **generally immutable** within the closure, ensuring consistency across different function executions. This immutability reduces **shared-state complexity** and helps prevent race conditions in concurrent programs.

---

## Parametric Polymorphism

Parametric polymorphism is a way to write generic, type-agnostic code. This is achieved using _Type Variables_.

### Type Variables

Type variables are placeholders for types. They allow you to define functions and data structures that can operate on any type. In OCaml, type variables are typically denoted by single letters like `'a`, `'b`, etc., often read as _alpha_, _beta_, etc.

```ml
let identity x = x;;
(* val identity : 'a -> 'a *)
```

- Here, `'a` (alpha) is a _type variable_ representing an unknown type in OCaml.

This _type variable_ allows the identity function to operate on values of any type, making it a polymorphic function.

Maybe you remember the type definition of the empty list:

```ml
[];;
(* : 'a list = [] *)
```

Here it's saying: "I'm a list that can be of any type", but it gets specialized when it receives elements:

```ml
"hola" :: [];;
(* : string list = ["hola"] *)
```

---

## Aliases

Like values you can give name to types:

```ml
type point = float * float;;
(* type point = float * float *)

let p1 : point = (1., 2.);;
(* val p1 : point = (1., 2.) *)
```

---

## Variants

OCaml supports features called **variants** or **algebraic data types** (ADTs) that are very similar to **enums** in other languages. Variants are used to define types that can take on different forms, allowing you to create new type definitions.

```ml
type primary_color = Red | Green | Blue;;
(* type primary_color = Red | Green | Blue *)

let r = Red;;
(* val r : primary_color = Red *)
let g = Green;;
(* val g : primary_color = Green *)
let b = Blue;;
(* val b : primary_color = Blue *)
```

Here we are defining a custom type `primary_color` that can be one of three options: `Red`, `Green` and `Blue`. These options are called **contructors** and serve as _custom tags_. In the first examples, we are binding one of those tags to a name and doing so the compiler interpret those bindings as types from **primary_color**.

Constructors can optionally carry data, allowing you to create more complex data structures. Let's see the next example:

```ml
type shape =
  | Point;;                     (* A point with no additional data *)
  | Circle of float             (* Circle with a radius *)
  | Rectangle of float * float;;(* Rectangle with width and height *)
(* type shape = Circle of float | Rectangle of float * float | Point *)

let p = Point;;
(* val p : shape = Point *)

let c = Circle 5.0;;
(* val c : shape = Circle 5. *)

let r = Rectangle (3.0, 4.0);;
(* val r : shape = Rectangle (3., 4.) *)
```

- `Circle`, `Rectangle`, and `Point` are the _variant constructors_.
- `Point` carries no additional data (similar to the _primary_color_ example).
- `Circle` carries a single float value representing the _radius_.
- `Rectangle` carries two float values representing the _width_ and _height_.

Constructors as you can see allow you to create new values from a variant type, different definition from constructors in OOP (Object Oriented Programming), which also contains methods.

---

## Pattern Matching

Pattern matching allows you to inspect the structure of data and extract values in a concise and expressive way. It's particularly useful for working with algebraic data types, such as variants and tuples. Pattern matching allows you to:

- Match against values (pretty similar to switch cases)
- Match against the shape of the data
- Extract parts of the data

### Syntax

The basic syntax for pattern matching in OCaml is:

```ml
let fun_name expression =
match expression with
| pattern1 -> result1 (* we call this a branch *)
| pattern2 -> result2
| ...

(* or its equivalent syntactic sugar *)
let fun_name expression = function
| pattern1 -> result1 (* we call this a branch *)
| pattern2 -> result2
| ...
```

- **expression** is the value you want to match against.
- **pattern1**, **pattern2**, etc., describe the shape of the data.
- **result1**, **result2**, etc., are the returned expressions if the corresponding pattern matches.

**Side Note:**
The entire match expression must be type-consistent, meaning all branches must return values of the same type, just like OCaml’s if expressions.

### Matching on Values

Pattern matching on values are very similar to switch cases but more powerful. In fact understanding switch cases is a good place to start.

```ml
let describe_number x =
  match x with
  | 0 -> "Zero"
  | 1 -> "One"
  | _ -> "Some other number";;
(* val describe_number : int -> string = <fun> *)

describe_number 1;;
(* : string = "One" *)

describe_number 42;;
(* : string = "Some other number" *)
```

**Explanation:**

- The function `describe_number` takes an integer `x`.
- It matches `x` against several patterns: `0`, `1`, and `_` which is a wildcard pattern that matches anything.

#### More Powerful than Switch Cases

- Allows you to match not just on values but also on the structure of data.
- Can warn you if you haven't covered all possible cases.
- Often results in shorter and more readable code.
- Does not have fall-through behavior, where forgetting a break statement can lead to unintended execution of subsequent cases.

### Matching on Lists

Lists can only be:

- nil (`[]`)
- the cons of an elemnt onto another list (`h :: t`)

So we can pattern match against those to ways:

```ml
let first_element lst =
  match lst with
  | [] -> "empty"
  | h :: t -> h;;
(* val first_element : string list -> string = <fun> *)

first_element [];;
(* : string = "empty" *)

first_element ["sapori"; "colori"];;
(* : string = "sapori" *)
```

**Explanation:**

- The function `get_first_element` takes a list `lst`.
- It matches the list against several patterns:
  - `[]` (empty list) → returns "empty".
  - `[x]` (single-element list) → returns `x`.
  - `h :: _` (non-empty list) → returns the first element `h`.

**Side Note:**  
In fact, pattern matching is type exaustive, preventing to write runtime error prone code:

```ml
let first_element lst =
  match lst with
  | [] -> "empty";;
(*
  [partial-match]: this pattern-matching is not exhaustive.
  Here is an example of a case that is not matched:
  _::_

  val first_element : 'a list -> string = <fun>
 *)
```

### Matching on Tuples

```ml
let has_zero (x, y) =
  match (x, y) with
  | (0, 0) -> "Both are zero"
  | (0, _) -> "First is zero"
  | (_, 0) -> "Second is zero"
  | _ -> "None is zero";;
(* val has_zero : int * int -> string = <fun> *)

has_zero (7,4);;
(* : string = "None is zero" *)

has_zero (0, 1);;
(* : string = "First is zero" *)
```

**Explanation:**

- The function `has_zero` takes a tuple `(x, y)` and matches it against specific patterns to determine whether any of the values are zero.

### Example: Matching on Records

```ml
type student = {
  name : string;
  grad_year : int;
}

let giorgio : student = {
  name = "Giorgio Rosa";
  grad_year = 1950
};;
(*
  type student = { name : string; grad_year : int; }
  val giorgio : student = {name = "Giorgio Rosa"; grad_year = 1950}
 *)

let name_with_year record =
  match record with
  | { name; grad_year } -> name ^ ", graduated in " ^ Int.to_string grad_year;;
(* val name_with_year : student -> string = <fun> *)

name_with_year giorgio;;
(* : string = "Giorgio Rosa, graduated in 1950" *)
```

### Example: Matching on Variants

```ml
type shape =
  | Circle of float
  | Rectangle of float * float

let area shape =
  match shape with
  | Circle radius -> Float.pi *. radius ** 2.
  | Rectangle (width, height) -> width *. height;;
(*
   type shape = Circle of float | Rectangle of float * float
   val area : shape -> float = <fun>
 *)

area @@ Circle 3.0;;
(* : float = 28.27... *)
area @@ Rectangle (2.0, 4.0);;
(* : float = 8. *)
```

**Explanation:**

- The `shape` type has two variants: `Circle` and `Rectangle`.
- The function `area` matches on the shape and extracts the relevant data:
  - `Circle radius` → computes the area as π \* radius².
  - `Rectangle (width, height)` → computes the area as width \* height.

### Example: Nested Patterns

Let's calculate the area of shapes when we have its cartesian points:

```ml
type point = float * float

type shape =
  | Circle of { center: point; radius: float }
  | Rectangle of { lower_left: point; upper_right: point }

let area shape =
  match shape with
  | Circle { center; radius } -> Float.pi *. radius ** 2.
  | Rectangle { lower_left; upper_right } ->
      let (x_lf, y_lf) = lower_left in
      let (x_ur, y_ur) = upper_right in
      (x_ur -. x_lf) *. (y_ur -. y_lf);;
(*
   type point = float * float
   type shape =
     Circle of { center : point; radius : float; }
   | Rectangle of { lower_left : point; upper_right : point; }
   val area : shape -> float = <fun>
 *)

area @@ Circle { center = (0. , 0.); radius = 1. };;
(* : float = 3.14159265358979312 *)
```

In this case we are extracting data from the record of a variant constructor but we can pattern match even more :

```ml
type point = float * float

type shape =
  | Circle of { center: point; radius: float }
  | Rectangle of { lower_left: point; upper_right: point }

let area shape =
  match shape with
  | Circle { center; radius } -> Float.pi *. radius ** 2.
  | Rectangle {
      lower_left = (x_lf, y_lf);
      upper_right = (x_ur, y_ur)
    } -> (x_ur -. x_lf) *. (y_ur -. y_lf);;
```

## Function Keyword

You can simplify the syntax of functions that use pattern matching by leveraging the `function` keyword. This keyword allows you to leave off the last argument and the beginning of the match expression, making your code more concise and readable.

### Simplifying with `function`

Consider the following function definition:

```ml
let f x y z =
  match z with
  | ...
```

You can rewrite it using the `function` keyword to streamline the pattern matching:

```ml
let f x y = function
  | ...
```

Let's take the previous example:

```ml
type shape =
  | Circle of float
  | Rectangle of float * float

let area = function    (* see the change here *)
  | Circle radius -> Float.pi *. radius ** 2.
  | Rectangle (width, height) -> width *. height;;
(*
   type shape = Circle of float | Rectangle of float * float
   val area : shape -> float = <fun>
 *)
```

**Explanation:**

- **Type Definition**: The `shape` type is a variant that can represent either a `Circle` with a radius or a `Rectangle` with width and height.
- **Function Definition**: The `area` function uses the `function` keyword to directly pattern match on the `shape` type. This eliminates the need for an explicit match expression.
- **Usage**:

```ml
area @@ Circle 3.0;;
(* : float = 28.27... *)
area @@ Rectangle (2.0, 4.0);;
(* : float = 8. *)
```

**Example: Summing a List**

Here's another example that demonstrates the use of the `function` keyword with a recursive function to sum the elements of a list:

```ml
let rec sum = function
 | [] -> 0
 | h :: t -> h + sum t
```

**Explanation:**

- **Function Definition**: The `sum` function uses the `function` keyword to pattern match on the list. If the list is empty (`[]`), it returns `0`. Otherwise, it adds the head (`h`) to the sum of the tail (`t`).
- **Usage**:

```ml
sum [1; 2; 3; 4];;
(* : int = 10 *)
```

---

# Congratulations

You've arrived at the final part of the article. Now you have the big picture of OCaml and can write your own code!

![Now you have powers!](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExODczNzBtejBwZnRlajE4ZTBtYTM0bmRmb2gxdHVqcm5zbHhwcXhrcyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/xT0xeORDq3lChYerTi/giphy.gif)
