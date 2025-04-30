let add x y = x + y

let sub x y = x - y

let div x y =
  if y = 0.
    then raise @@ Invalid_argument "Division by 0"
    else x /. y

let safe_div x y =
  try
    Ok (div x y)
  with
    | Invalid_argument msg -> Error ("Invalid argument: " ^ msg)