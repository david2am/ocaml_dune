val add : int -> int -> int
(** [add x y] returns the result of x + y. *)

val sub : int -> int -> int
(** [sub x y] returns the result of x - y. *)

val safe_div : float -> float -> (float, string) result
(** [safe_div x y] returns the result of x /. y if y <> 0 otherwise returns an Error *)