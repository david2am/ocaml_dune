# Functional Programming and Why OCaml?

I'd like to express my gratitude to Richard Feldman for his incredible teachings in Functional Programming and to Professor Michael Ryan Clarkson for creating such a wonderful course.

With this guide, I hope to contribute to the community by showcasing the beauty and practicality of functional programming - emphasizing that it's just *different*, not difficult. There's a lack of beginner-friendly tutorials out there, and I aim to fill that gap.

## References

- [Distributed Pure Functions by Richard Feldman](https://www.youtube.com/watch?v=ztY1YRiaSiE&t=1803s)
- [Why Isn't Functional Programming the Norm?](https://www.youtube.com/watch?v=QyJZzq0v7Z4&t=1s)
- [OCaml Programming: Correct + Efficient + Beautiful](https://www.youtube.com/watch?v=MUcka_SvhLw&list=PLre5AT9JnKShBOPeuiD9b-I4XROIJhkIU)
- [Intro to OCaml + Functional Programming](https://www.youtube.com/watch?v=spwvg0DThh4&t=46s)
- [Functional Programming for Pragmatists](https://www.youtube.com/watch?v=3n17wHe5wEw&t=288s)
- [Ditch your Favorite Programming Paradigm](https://www.youtube.com/watch?v=UOkOA6W-vwc)

Happy reading! 🚀

---

# Imperative vs Declarative Programming

## Think of it like cooking:

**Imperative programming** is like giving detailed step-by-step cooking instructions:
1. Take out a pan
2. Heat it to medium
3. Add 1 tablespoon of oil
4. Crack 2 eggs into the pan
5. Stir for 2 minutes
6. Add salt and pepper

**Declarative programming** is like saying "Make me scrambled eggs, please" - you specify *what* you want, not *how* to do it.

Functional Programming (FP) is a declarative way of writing programs. It focuses on telling the computer *what* result you want, hiding the detailed mechanics of *how* to get there.

This makes your code more:
- Expressive
- Easy to read
- Easier to maintain
- More focused on solving problems than implementation details

 *Note:*  
 Some may be concerned that the higher level of abstraction in functional programming (FP) could lead to slower programs. However, this is not always the case. For instance, OCaml, a functional language, can achieve performance comparable to that of C.

---

# Functional Programming Basics

In FP, everything is an expression —including functions— so programs are just compositions of expressions. Like math formulas, expressions evaluate to values rather than following step-by-step instructions, as in imperative programming.

### Core Principles of FP  

✅ No Side Effects  
✅ No Shared State  
✅ Immutable Data

## No Side Effects

In general, there are 2 types of side effects *external* and *internal*. *External* **side effects** occurs when a program interacts with the external world, such as reading from a file, writing to a database, or displaying output. On the other hand, *internal* **side effects** occurs when a code entity (function, method, object, etc.) mutate state outside its own scope.

```md
            outside
              |
outside <-  SYSTEM  -> outside
              |
            outside
```

*External* **side effects** are unavoidable because are necessary to interact with the external world. But FP discourage the use of *internal* side effects because they can lead to unexpected behaviors.

**Example:**
```ocaml
(* Function with side effect - prints to console *)
let greet name =
  print_string ("Hello, " ^ name ^ "!\n")

(* Pure function - no side effect *)
let greeting name =
  "Hello, " ^ name ^ "!"
```

## No Shared State

Expressions do not share state directly; instead, they operate on copies of data, ensuring modifications in one of them don't generate side effects in another.

**Example:**
```ml
(* Define a function that takes a list and returns a new list with an element added *)
let add_element lst elem =
  elem :: lst
```

## Immutable Data

In functional programming, data is immutable, meaning it cannot be changed once created. If updates are necessary, new versions of the data are generated. Since each expression operates on a copy, internal operations do not affect the original data.

**Example:**
```ocaml
(* Immutable list operations *)
let numbers = [1; 2; 3]
let added = 0 :: numbers     (* Creates new list [0; 1; 2; 3] *)
let mapped = List.map (fun x -> x * 2) numbers  (* Creates new list [2; 4; 6] *)

(* Original list remains unchanged *)
(* numbers is still [1; 2; 3] *)
```

---

# FP Cornerstones

To apply those principles FP uses:

✅ * **Expressions**  
✅ * **Lexical Scope**  
✅ Pure Functions  
✅ First-Class Functions  

FP revolves around the use of **expressions** and **lexical scope**. Pure functions and closures are natural byproducts of expressions and well-defined scope.  

While not covered here, these concepts also serve as the foundation of recursion, partial applications (or currying), lazy evaluation and more, which we will explore in depth in a future article.


## Expressions

Expressions are code constructs that evaluate to a value without altering the program's state. In FP, even control structures like if-then-else return values!

**Examples:**
```ml
(* Pseudocode for expressions *)
let val1 = expression_1 (* evaluates to a value *)
let val2 = expression_2 (arg = val1) (* expression_2 uses copies of val1 without modifying them *)


(* Pseudocode for instructions *)
let val1 (* value declaration *)

computation_1 (* modifies val1 *)

let val2 (* value declaration *)

computation_2 (arg = val1) (* modifies val2 *)
```

As illustrated, traditional computations can lead to side effects, making code harder to maintain. On the other hand, expressions always return values, **encouraging** that evaluation take place outside their scope, avoiding mutations and side effects on other internal scopes.


## Lexical Scope 

In lexical scoping, the scope of a variable is determined by its location within the source code, specifically where it is declared. This means that the scope is resolved at compile time based on the structure of the code, rather than at runtime based on the execution context, which makes it easier to reason about in comparison with dynamic scoping for example.

### Function Parameters
Internally, they act as value copies rather than references to the original arguments. This prevents unintended modifications to the original data.

### Local variables and immutability
Variables declared within a specific scope (such as inside a function) are intended to be immutable, reinforcing predictability and referential transparency.

### Lexical Scoping and Closure
When a higher-order function creates a closure, it captures variables from its surrounding scope. These captured variables are usually treated as immutable within the closure, ensuring they remain consistent across different function executions. This also helps prevent unexpected modifications from other parts of the program, reducing shared-state complexity and race conditions in concurrent execution.


## Pure Functions

Pure functions always produce the same output for the same input and have no side effects - just like mathematical functions!

**Example:**
```ocaml
(* Pure function *)
let square x = x * x

(* Always returns 16 *)
square 4
```

In other words, are expressions that **have no** side effects at all.


## First-Class Functions

In functional programming, functions are a special type of value. This means they can be passed as arguments, returned from other functions, and assigned to variables. Functions that take other functions as arguments or return functions as results are called **higher-order functions**. These enable function composition and closure creation, which, as discussed earlier, establish their own scope and help avoid shared state between entities.

**Example:**
```ocaml
(* A function that takes another function as input *)
let apply_twice f x = f (f x)

(* Passing different functions to apply_twice *)
let result1 = apply_twice (fun x -> x * 2) 3    (* Returns 12 *)
let result2 = apply_twice (fun x -> x ^ "!") "hi"  (* Returns "hi!!" *)
```


---

# FP Shines in Concurrent and Parallel Programs

Whenever you need better fault tolerance and availability you need concurrency and/or parallelization, and their best feet is FP because it offers:

✅ Safe Parallelization  
✅ Safe Data Sharing  
✅ Sage Threads

## Safe Parallelization

Since FP avoids side effects, operations can run independently over iterable data structures, such as arrays, tuples, etc, without fearing unexpected behaviors.

**Example:**

```ocaml
(* Can safely run parallel_function_expression independently over each list element because no shared state is modified *)
let processed_customers = 
  List.map (parallel_function_expression) customers
```

## Safe Data Sharing

Since data is immutable (unchangeable), it can be safely shared across different parts of your program.

**Example:**
```ocaml
(* This data can be shared safely across threads *)
let data = [("timeout", "30"); ("retries", "3")]

(* Every thread can access 'data' without worrying about it changing *)
```

## Thread Safety

Immutable data prevents race conditions (where multiple threads try to modify the same data simultaneously).

**Example:**
In languages with mutable data:
```python
# Potential race condition if two threads run this
counter += 1
```

In functional programming:
```ocaml
(* No race condition - creates new value instead of modifying *)
let new_counter = counter + 1
```

---

# Ocaml

OCaml's approach makes functional programming both powerful and accessible. While it may differ from what you're used to, with practice, it becomes an intuitive and effective way to write clean, reliable code!

### Why Choose OCaml for Functional Programming?

✅ Balanced FP  
✅ Correctness  
✅ Speed (as fast as C)  

## Balanced FP 

OCaml allows mutation when it's truly necessary. For specific use cases, creating a long data list every time a change is needed can be inefficient. Therefore, OCaml allows you to prioritize performance over dogmatic adherence to immutability:

**Example:**
```ocaml
(* Imperative style with shared state *)
let counter = ref 0
let increment () = counter := !counter + 1

(* Functional style - no shared state *)
let increment count = count + 1
```

But OCaml still adheres to FP principles:  
✔︎ No Side Effects  
✔︎ No Shared State  
✔︎ Immutable Data 

An also their advantage for fault tolerance and high availability systems are maintained:  
✔︎ Safe Parallelization  
✔︎ Safe Data Sharing  
✔︎ Safe Threads

## Correctness

OCaml's strong type system adds an extra layer to detect errors at compile time, preventing security vulnerabilities and enhancing code clarity and readability. It is so powerful that you often don't need to explicitly define every type; the compiler can infer types from your code.

**Example:**
```ml
(* OCaml won't let this run. The '+' operator works with numbers, not strings, so `x` is expected to be a number. *)
let buggy x = x + "hello"  (* Type error! *)

(* The type system helps you write correct code. *)
let safe_concat x = string_of_int x ^ "hello"  (* Works correctly *)
```

As demonstrated, explicit type definitions are often unnecessary due to OCaml's type inference capabilities.

## Speed

OCaml is renowned for its performance, often achieving speeds comparable to C. This makes it an excellent choice for applications where efficiency is critical.