let () =
  Alcotest.run "Alcotest_action"
    [ Alcotest_tests.Headline_tests.tests; Alcotest_tests.Output_tests.tests ]
