group "default" {
  targets = ["builder "tester"]
}

target "builder" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "builder"
}

target "tester" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "tester"
}