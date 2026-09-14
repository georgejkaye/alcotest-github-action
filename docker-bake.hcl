target "builder" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "builder"
}

target "builder_export" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "builder_export"
}

target "tester" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "tester"
}

target "tester_export" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "tester_export"
}