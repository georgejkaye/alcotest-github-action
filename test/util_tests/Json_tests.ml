open Yojson
module Json = Lib.Util.Json

let remove_nulls () =
  let json =
    `Assoc
      [
        ("test", `String "hello");
        ("test2", `Int 3);
        ("test4", `Null);
        ( "test4",
          `List
            [
              `Assoc [ ("test5", `Null); ("test6", `Int 4) ];
              `Null;
              `Assoc [ ("test5", `Int 4); ("test6", `Null) ];
            ] );
      ]
  in
  let expected =
    `Assoc
      [
        ("test", `String "hello");
        ("test2", `Int 3);
        ( "test4",
          `List [ `Assoc [ ("test6", `Int 4) ]; `Assoc [ ("test5", `Int 4) ] ]
        );
      ]
  in
  let result = Json.Yojson.remove_nulls json in
  Alcotest.check Helpers.Testable.yojson "remove_nulls" expected result

let tests =
  ("Util.Json", [ Alcotest.test_case "remove_nulls" `Quick remove_nulls ])
