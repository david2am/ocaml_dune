---

# DRAFT

What some people consider is cool about FP:

- Higher-order functions
- Purity

Powerfal language features in one single lenguage:

- immutability by default
- pattern matching
- type system
- ADTs

What really matters

- Correctness
- Expressive static types
- Dexterity/pragmatic

Environments where it shines:

1. High predictavility and high relaibility
2. High performance and high complexity systems

3. Compiler and language design
4. Formal verification and theorem proving

Places where it shines:

- financial env
- aerospace and avionics
- medical devices
- chriptographic systems and security protocols
- academic and researh
- distributing systems and networking (where it's currently growing)

# Presentation Structure

1. OCaml Features
2. Industries Where it Excels
3. Developer Experience

# IDEAS

```py
def sum(list):
  total = 0
  for num in list:
    total = total + num
  return total
```

```ocaml
let rec sum list =
  match list with
  | [] -> 0
  | first :: rest -> first + sum rest
```

Normal laguages doesn't have a wide range of problems, but OCaml does.

OCaml:

- consice -> short and clear
- efficient -> do what you expect
- practical -> focus on reducing complexity
---
```py
def sum(list):
  total = 0
  for num in list:
    total = total + num
  return total
```

```ocaml
let rec sum list =
  match list with
  | [] -> 0
  | first :: rest -> first + sum rest
```

# PRESENTATION

## Sources

- [Why Functional Programming Doesn't Matters](https://www.youtube.com/watch?v=kZ1P8cHN3pY)  
  Correctness, Dexterity and Performance
- [Why OCaml](https://www.youtube.com/watch?v=v1CmGbOGb2I&t=2556s)  
  Typed functional language -> correctness and performance
- [Real World OCaml](https://dev.realworldocaml.org)
  Some examples
- [Algebraic Data Types](https://patternmatched.substack.com/p/algebraic-data-types?r=327h32&triedRedirect=true)
  ADTs
- [Hindley-Milner Type Inference](https://www.youtube.com/watch?v=_yDo9Q9EOHY)

---

## 🟣 The Beginning

About a year ago, I started exploring a new programming language in my spare time. I was curious—looking for something **performant**, a bit closer to the metal than JavaScript or Python, but not as low-level as C or Rust.

You might know that feeling: wanting to expand your skills, challenge how you think, and explore tools that help you see the craft of programming from a new angle.

That curiosity led me to **Zig** —a systems programming language that makes you think differently about memory, types, and safety. I enjoyed it, but I also noticed something: while I was learning a lot, I missed being able to iterate fast and focus early on business logic.

You've probably experienced that trade-off before—between control and productivity, performance and velocity. But here's the thing: why should we have to choose?

---

## 🟣 The Spark

Around that time, I started watching developer podcasts and talks. No code, just conversations.

At first, it felt strange. Where's the code? I thought.

Soon, I noticed they were talking about types, correctness, and functional programming—ways to write software that's easier to reason about, safer by design, and structured with clarity, I realized they were talking beyond frameworks and if you are a Web Dev like me you know what I'm talking about.

It was a bit over my head, honestly—but it was also exciting.

So I learned more about it and now I wasn't looking for a language just performant but also functional that let me be more intentional more balanced and expresive.

I couldn't shake this feeling, trying to find a balance between performance and expressiveness and correctness, something that let you focus on the doing, on the business behind it, and maybe you also have had that too.

That's when I found a talk called "Taking Erlang to OCaml 5" by Leandro Ostera in the YouTube podcast of Developer Voices. He said something that really stayed with me:

"I was stuck in the rut of a web developer, realizing for the first time that everything I do is move JSON in and out of a database into a form on a Web. There has to be more."

I felt that. Maybe you do too. But here's what hit me: if we all feel this way, why aren't we doing something about it?

Not because web development isn't valuable—it absolutely is. I love the impact we can make through web experiences. But sometimes, you want to push beyond that. To understand more. To grow.

---

## 🟣 The OCaml Moment

That's how I discovered OCaml. And it wasn't by accident—it was because I was actively looking for an answer.

You might not know much about it. I didn't either. But what I found was intriguing:

- **Functional** – helping you write expressive, correct-by-construction code
- **Performant** – used in high-stakes industries like finance, AI, and developer tooling
- **Mature** – built over decades, with a strong type system and growing ecosystem

The question became: if you're a web developer today, OCaml might seem far off. But what if its ideas could sharpen how you reason about components, APIs, business rules, and data flow?

Maybe the solution isn't just learning another framework—maybe it's learning to face your problems differently.

---

## 🟣 The Beauty Behind the Language

So, let's zoom into what makes OCaml different—and why it might matter to you.

### The Code That Changed Everything

Later on I was actively studiying OCaml from proffesor Michael Clarkson on YouTube and I finish to write the piece of code that made me fall in love with OCaml 🌷:

```ocaml
type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree

let t =
  Node (1, Node (2, Leaf, Leaf), Node (3, Leaf, Leaf))

let rec size = function
  | Leaf -> 0
  | Node (_, l, r) -> 1 + size l + size r

let rec sum = function
  | Leaf -> 0
  | Node (v, l, r) -> v + sum l + sum r

let rec map f = function
  | Leaf -> Leaf
  | Node (v, l, r) -> Node (f v, map f l, map f r)

let rec fold acc f =
match acc with
  | Leaf -> acc
  | Node (v, l, r) -> f v (fold acc f l) (fold acc f r)

let sum = fold 0 (fun x y z -> x + y + z)
```

Pause for a moment and think about how complicated this would be in imperative languages 🤢

This wasn't just learning new syntax—I was experiencing a completely new way of thinking. But here's what troubled me initially: it seemed almost too simple. How could something this elegant actually work in the real world?

Let me promise you one thing: "OCaml is easy, it's just different"—especially when dealing with complexity. But that difference is exactly what makes it powerful.

---

## 🟣 The Fundamentals That Matter

As I dove deeper, I discovered OCaml's elegance comes from a few core principles.

The first thing that you need to know is that OCaml is functional first language and as such:

**Everything is either a definition or an expression:**

```ocaml
let num = 3          (* a definition *)
let sum x y = x + y  (* a function definition *)
```

**Even conditionals are expressions:**

```ocaml
"hola " ^ "mundo!"
2 + 5
let result = if condition then a else b
```

**Everything is immutable by default:**

```ocaml
let pi = 3.1     (* val pi : float = 3.1 *)
pi     = 3.1415  (* : bool = false *)
let pi = 3.1415  (* val pi : float = 3.1415 *)
```

///

### Higher-order functions

Functions as any other values.

Allow you to define your own control flow mechanisms

- by defining your own control flow mechanisms
- by providing a way of inversion of control (a code client is decoupled from its modules)

### Purity

Function behaviour should only depends only in its input.

Allow easy composition avoiding side-effects, which can be seen as an emerging property of a system that is hard to reason about.

///

And here's where it gets interesting: OCaml doesn't have switch/case. Instead, it gives you something better—pattern matching.

```ocaml
type shape =
  | Circle of float            (* radius *)
  | Rectangle of float * float (* width & height *)

let area shape =
  match shape with
  | Circle radius -> Float.pi *. radius ** 2.
  | Rectangle (width, height) -> width *. height;;
```

**Flexibility:**

```ocaml
let next =
  let counter = ref 0 in
  fun () ->
    incr counter;
    !counter
  ;;
```

OCaml has support for purity, but if forcing something to be pure introduce more complexity the goal of purity is lost but OCaml offers expresive ways to deal with side effects through some optionally imperative style.

## 🟣 My Second Realization: It's Not Just Beautiful—It's Practical

But my second realization was even bigger, and it came from a frustrating truth:

With scripting languages and even low-level languages, reliability depends on the coder's expertise.

But what happens when you're tired? When you're under pressure? Or when you are still learning best practices?

In TypeScript or any scripting language, coding highly reliable code is difficult.

Maybe, you can say to me that you can achieve anything with your current laguage, but let me ask you something: how confident are you about what you just wrote? How confident is your team?

To get similar confidence in TypeScript, state machine libraries become necessary to have near 100% certainty about the code you just built. But that's extra complexity, extra dependencies, extra things that can break.

With OCaml, you get that by default, as you'll see in the next section. Therefore, the language itself becomes your safety net.

### What Really Matters: The Three Pillars

Through my exploration, I discovered OCaml excels in three key areas and these aren't just features—they're solutions to problems we face every day.

- **Correctness** – It helps you deliver exactly what you intended, with safety and reliability built in, encouraging you to think about errors right from the start.
- **Dexterity** – The lifting power and agility that allows you to get things done quickly, efficiently, and safely.
- **Performance** – Native compilation and static typing that doesn't sacrifice expressiveness for speed.

But you might be asking: "How does this actually work in practice?" Let me show you.

## 🟣 Correctness: Your Safety Net

### Constraints Are Actually Good

We've all been taught that constraints limit creativity. But what if that's wrong?

Typed languages offer constraints, which is good—as long as they're oriented toward writing correct, explicit code, and that is exactly what happens with OCaml.

OCaml's type system is expressive. You need few words to say important things. In OCaml constraints become tools, not obstacles, they help you to stay on track.

If you still need some proves let's show you this common examples:

**Compiled errors become your friend:**

```ocaml
let add_potato x = x + "potato"
(* Error: This expression has type string but an expression was expected of type int *)
```

Instead of discovering this at runtime (probably in production), you catch it immediately. But what about more subtle issues?

**Pattern matching catches incomplete cases:**

```ocaml
let my_favorite_language (my_favorite :: the_rest) = my_favorite;;
(* Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
[] *)
```

As you see the compiler complains because it knows that your code is not exhaustive and give you a hint:

**So you handle all cases:**

```ocaml
let my_favorite_language languages =
  match languages with
  | first :: the_rest -> first
  | [] -> "OCaml" (* A good default! *);;
```

Therefore, you're forced to think about edge cases before they become bugs in production.

## 🟣 Dexterity: Power and Agility

### Type Inference That Actually Helps

Here's a common problem: you want strong typing, but you don't want to write verbose type annotations everywhere. It feels like you have to choose.
But the Hindley-Milner type inference system treats type constructs as equations, letting you focus on business logic, not type annotations:

```ocaml
let sum x y = x + y;;
(* val sum : int -> int -> int = <fun> *)

let first_if_true f x y = if f x then x else y;;
(* val first_if_true : ('a -> bool) -> 'a -> 'a -> 'a = <fun> *)
```

Therefore, you get the benefits of strong typing without the verbosity. But there's more...

### Making Illegal States Unrepresentable

Here's where it gets really interesting. Remember our shape example? What happens in the real world when business requirements change? Usually, chaos.
Watch what happens when business requirements change in OCaml, let's say that now you add a new shape, the `Triangle`:

```ocaml
type shape =
  | Circle of float
  | Rectangle of float * float
  | Triangle of float * float  (* new requirement! *)

let area shape =
  match shape with
  | Circle radius -> Float.pi *. radius ** 2.
  | Rectangle (width, height) -> width *. height
(*  Warning 8 [partial-match]: this pattern-matching is not exhaustive.
Here is an example of a case that is not matched:
Triangle (_, _) *)
```

The compiler tells you exactly what you missed. Fix it, and you're done:

```ocaml
let area shape =
  match shape with
  | Circle radius -> Float.pi *. radius ** 2.
  | Rectangle (width, height) -> width *. height
  | Triangle (base, height) -> (base *. height) /. 2.
```

**The big insight:** Business logic becomes code in your type system, converting OCaml's compiler into your helper. Therefore, when requirements change, you can't forget to update related code—the compiler won't let you.

## 🟣 Performance: Speed Without Sacrifice

OCaml is compiled, statically typed, and one of the few languages that's as expressive as it is performant. The problem with most performant languages is: they force you into low-level complexities, shifting your focus from business logic to implementation details.

OCaml lets you stay focused on what matters. Therefore, you don't have to choose between performance and productivity.

## 🟣 My Third Realization: The Niche That Matters

OCaml's sweet spot is high-predictability, high-reliability, high-performance environments—in other words, critical systems. But why should you care about critical systems?

That's why companies like Jane Street and Tezos use OCaml daily in production. But they didn't choose it for fun—they chose it because failure has real consequences.

**Where OCaml shines:**

- Financial environments
- Aerospace and avionics
- Medical devices
- Cryptographic systems and security protocols
- Compiler and language design
- Formal verification and theorem proving
- Distributed systems and networking (where it's currently growing)

**The pattern:** When failure isn't an option, OCaml becomes an option.

---

## The End

OCaml enables you to write highly predictable, reliable, and performant programs, which are especially valued in the development of critical systems.

Indeed, you can integrate business logic directly into the program through the type system, verifying your business rules just like any other type using variants and pattern matching.

This makes OCaml essential if you or your business prioritize:

- Predictability
- Reliability
- Performance
- Ease of maintenance

<!--my intention is: create an OCaml community within the company.-->

## 🟣 What It Might Mean for You

So, here's where this comes back to you.

If you're a developer, maybe you're already exploring functional programming. Or maybe you're just feeling the itch to try something different—something that pushes you to level up not just in syntax, but in mindset.

Languages like OCaml can help you:

- Think more precisely
- Reduce bugs at the root
- Model systems that are easier to test and maintain

But here's what really caught my attention: when you dive into it, you start to think differently. You model problems more clearly. You avoid entire classes of bugs. And that kind of thinking doesn't just stay in OCaml—it flows back into everything you build.

You don't need to make a full switch. You just need curiosity—and a willingness to try.

Sometimes, the technologies that feel niche today quietly power tomorrow's most trusted systems.

And often, the developers exploring them early are the ones who bring back better ideas, stronger solutions, and more resilient codebases.

That's how we stay ahead—not by chasing trends, but by learning deeply and thinking long-term.

## 🟣 Let's Explore Together

So here's my invitation:

If you're a developer and any of this sparked your curiosity, I'd love to explore it with you.

I'm building small things, writing, sharing, and learning in public—and it would be even better with a few teammates.

And if you're on the business side and you're wondering where some of tomorrow's strategic advantages might come from—it could be from things like this: new paradigms, new ways of building, and new thinking that sharpens what we already do well.

Let's stay in touch. Let's keep growing.

Thank you.
