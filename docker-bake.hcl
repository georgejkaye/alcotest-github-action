target "_common" {
  context    = "."
  dockerfile = "Dockerfile"
}

target "builder" {
  inherits = ["_common"]
  target   = "builder"
}

target "builder_export" {
  inherits = ["_common"]
  target   = "builder_export"
  contexts = {
    builder = "target:builder"
  }
}

target "tester" {
  inherits = ["_common"]
  target   = "tester"
  contexts = {
    builder = "target:builder"
  }
}

target "tester_export" {
  inherits = ["_common"]
  target   = "tester_export"
  contexts = {
    tester = "target:tester"
  }
}

