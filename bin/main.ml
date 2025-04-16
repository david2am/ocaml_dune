open Lib

let () =
  let result = Math.add 2 3 in
  print_endline (Int.to_string result);
  
  let result = Math.sub 3 1 in
  print_endline (Int.to_string result)
