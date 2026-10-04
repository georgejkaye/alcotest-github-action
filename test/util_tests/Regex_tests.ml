let get_regex =
  let regex_string = "match is {(.*)}" in
  let regex = Lib.Util.Regex.get_regex regex_string in
  let input_string = "match is {test}" in
  let expected = "test" in
  let result = Re.exec regex input_string |> fun res -> Re.Group.get res 1 in
  Alcotest.check Helpers.Testable.string expected result

let tests = ("Util.Regex", [ Alcotest.test_case "get_regex" `Quick get_regex ])
