# When Failure is Not an Option: A Practical Case for OCaml

<img src="https://images.unsplash.com/photo-1567361808960-dec9cb578182?q=80&w=895&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D">
Foto de <a href="https://unsplash.com/es/@louishansel?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Louis Hansel</a> en <a href="https://unsplash.com/es/fotos/herramientas-de-carpinteria-de-tipo-surtido-sobre-superficie-marron-Rf9eElW3Qxo?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>

## Sources

- [Why Functional Programming Doesn't Matters](https://www.youtube.com/watch?v=kZ1P8cHN3pY)
- [Why OCaml](https://www.youtube.com/watch?v=v1CmGbOGb2I&t=2556s)
- [Real World OCaml](https://dev.realworldocaml.org)
- [Algebraic Data Types](https://patternmatched.substack.com/p/algebraic-data-types?r=327h32&triedRedirect=true)
- [Hindley-Milner Type Inference](https://www.youtube.com/watch?v=_yDo9Q9EOHY)

---

## 🟣 A New Perspective on Programming

About a year ago, I was looking for a new programming language to learn in my spare time. I wanted something more performant than JavaScript or Python, but less intimidating than C or Rust.

My curiosity led me to Zig, a systems programming language that forces you to think differently about memory and safety. I enjoyed the experience, but I also felt a familiar tension—the trade-off between fine-grained control and rapid productivity. Why should we have to choose?

That's how I discovered OCaml.

---

## 🟣 The "Aha!" Moment with OCaml

I used to think the solution to my programming problems was learning another framework. With OCaml, I realized it's about learning to _think_ about problems differently. Here’s what makes OCaml special:

I was experimenting with a language that rarely boasts both expressiveness and high performance. How could something so elegant be so effective in the real world?

---

## 🟣 OCaml core Principles

OCaml's elegance comes from a few functional principles.

### Everything is an Expression

In OCaml, almost everything is an expression that returns a value. This includes not just calculations but even conditionals.

```ocaml
(* Definitions are like permanent assignments *)
let num = 3
let sum x y = x + y

(* Even conditionals are expressions that return a value *)
let result = if condition then "this value" else "that value"
```

### Functional to the Core

OCaml encourages a functional style, which leads to more predictable and maintainable code.

- **Immutability by Default:** Once a value is defined, it can't be changed. This eliminates a whole class of bugs related to unexpected state changes.

  ```ocaml
  let pi = 3.1     (* pi is now 3.1 *)
  (* pi = 3.1415  <- This would be an error *)
  let pi = 3.1415  (* This creates a *new* value for pi *)
  ```

- **Higher-Order Functions:** Functions are treated like any other value. You can pass them as arguments, return them from other functions, and store them in data structures.

  ```ocaml
  (* 'List.fold_left' takes a function as its first argument *)
  let sum lst =
    List.fold_left (fun acc el -> acc + el) 0 lst
  ```

- **Purity:** A pure function's behavior depends only on its inputs. This makes functions easier to reason about, compose, and test because there are no hidden side effects.

  Consider this Python function, which relies on a `total` variable that changes over time (a side effect):

  ```python
  def sum(list):
    total = 0
    for num in list:
      total = total + num
    return total
  ```

  Now, look at the OCaml equivalent, which is a pure function:

  ```ocaml
  let rec sum list =
    match list with
    | [] -> 0
    | first :: rest -> first + sum rest
  ```

### Practicality When You Need It

While OCaml encourages purity, it's also pragmatic. In situations where controlled mutation can simplify code, OCaml provides a clear and expressive way to handle it.

```ocaml
let next =
  let counter = ref 0 in
  fun () ->
    incr counter;
    !counter
```

---

## 🟣 The Three Pillars of OCaml

You might be thinking, "I can do all of this in my current language." And you're probably right. But let me ask you: how confident are you in the code you just wrote? Would you bet your company's most critical system on it?

At least in the TypeScript world, we often add state machine libraries to gain a high degree of confidence. But that means extra dependencies, more complexity, and more things that can break.

With OCaml, that confidence comes built-in. The language itself is your safety net.

My exploration revealed that OCaml excels in three key areas that solve everyday programming challenges:

- **Correctness:** It helps you deliver what you intended with safety and reliability baked in.
- **Dexterity:** It gives you the power and agility to get things done quickly, efficiently, and safely.
- **Performance:** It offers native compilation and static typing without sacrificing expressiveness.

Let's see how this works in practice.

---

## 🟣 Correctness: Your Built-in Safety Net

### Thinking in Edge Cases

OCaml's compiler forces you to consider edge cases from the start:

```ocaml
let my_favorite_language (my_favorite :: the_rest) = my_favorite;;
(* Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
[] *)
```

You're encouraged to handle all possibilities using **pattern matching**, a powerful feature that's like a switch statement on steroids.

```ocaml
let my_favorite_language languages =
  match languages with
  | first :: the_rest -> first
  | [] -> "OCaml" (* A sensible default! *)
```

### Making Illegal States Unrepresentable

This is OCaml's superpower. Imagine you have a `shape` type:

```ocaml
type shape =
  | Circle of float
  | Rectangle of float * float
```

When business requirements change and you need to add a `Triangle`, you simply update the type:

```ocaml
type shape =
  | Circle of float
  | Rectangle of float * float
  | Triangle of float * float  (* base, height *)
```

The compiler then becomes your assistant, pointing out every function that doesn't yet handle `Triangle`.

```ocaml
let area shape =
  match shape with
  | Circle radius -> Float.pi *. radius ** 2.
  | Rectangle (width, height) -> width *. height

(*
  Error (warning 8): this pattern-matching is not exhaustive.
  Here is an example of a case that is not matched:
  Triangle (_, _)
 *)
```

Your business logic is encoded in the type system. Once you fix the errors, you can be confident the code is correct.

## 🟣 Dexterity: Power and Agility

### Type Inference That Helps, Not Hinders

OCaml provides strong typing without the verbose annotations. Its powerful type inference system understands your code and deduces the types for you, letting you focus on logic.

```ocaml
let sum x y = x + y;;
(* val sum : int -> int -> int = <fun> *)
```

This means you get the safety of strong typing without the boilerplate. When you make a mistake, the error messages are your friend.

```ocaml
let add_potato x = x + "potato"
(* Error: This expression has type string but an expression was expected of type int *)
```

You get the benefits of strong typing with the feel of a dynamic language, giving you the agility to refactor and build with confidence.

## 🟣 Performance: Speed Without Sacrifice

OCaml is a compiled, statically-typed language that offers a rare combination of high-level expressiveness and raw performance.

- Its **native code compiler** produces fast, optimized executables.
- It provides **zero-cost abstractions**, so you can write elegant code without a performance penalty.
- Its **predictable garbage collector** is ideal for low-latency systems.

OCaml lets you focus on your business logic without hitting a performance ceiling.

---

## 🟣 What This Might Mean for You

OCaml is, to my way of thinking, the only language out there today that has the right balance between: performance, expressiveness and practicality.

If you're a developer, exploring a language like OCaml can help you build more precise, maintainable, and bug-free systems. The lessons you learn will flow back into everything you build, regardless of the language.

---

## 🟣 Why This Matters

OCaml's sweet spot is in high-predictability, high-reliability, and high-performance systems. When failure is not an option, OCaml becomes an option.

This is why it's trusted in production by companies in the most demanding fields:

Finance: Jane Street
Developer Tools: Docker
Web Services: Ahrefs
Blockchain: Tezos

The pattern is clear: **when failure is not an option, OCaml becomes an option.**

---

## 🟣 Let's Explore Together

If any of this sparked your curiosity, I'd love to explore it with you. I'm building small things, writing about my journey, and learning in public.

Let's stay in touch. Let's keep growing.

Thank you.
