open Math

let () =
  let result = Calc.add 2 3 in
  print_endline (Int.to_string result);
  
  let result = Calc.sub 3 1 in
  print_endline (Int.to_string result)


(* open ANSITerminal

let () =
  print_string [Bold; green] "\n\nHello in bold green!\n";
  print_string [red] "This is in red.\n" *)