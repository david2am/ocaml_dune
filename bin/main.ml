open Math

let () =
  let result = Calc.add 2 3 in
  print_endline (Int.to_string result);
  
  let result = Calc.sub 3 1 in
  print_endline (Int.to_string result)
