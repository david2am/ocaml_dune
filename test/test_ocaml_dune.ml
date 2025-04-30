let test_hello () =
  Alcotest.(check string) "same string" "hello" "hello"

let () =
  Alcotest.run "My Project" [
    "hello", [
      Alcotest.test_case "Hello test" `Quick test_hello;
    ];
  ]