open Math

let () =
  let result = Calc.add 2 3 in
  print_endline (Int.to_string result);
  
  let result = Calc.sub 3 1 in
  print_endline (Int.to_string result);

  let result = Calc.safe_div 300. 0. in (* Implementation details on Practical OCaml.md*)
  let value = Result.value result ~default:0. in
  print_endline (Float.to_string @@ value)


(* open ANSITerminal

let () =
  print_string [Bold; green] "\n\nHello in bold green!\n";
  print_string [red] "This is in red.\n" *)