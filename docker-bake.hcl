target "_common" {
  context    = "."
  dockerfile = "Dockerfile"
}

target "builder_export" {
  inherits = ["_common"]
  target   = "builder_export"
}

target "tester_export" {
  inherits = ["_common"]
  target   = "tester_export"
}
