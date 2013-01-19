Gem::Specification.new do |spec|
  spec.name         = "chomsky"
  spec.version      = "0.1.0"
  spec.summary      = "Pure-Ruby parsing expression grammar generator"
  spec.description  = "Chomsky generates parsing expression grammars with " +
    "a nice pure-Ruby DSL, eliminating the need for secondary grammar definition " +
    "files or out-of-band compilation, and allowing a grammar's rules to grow " +
    "dynamically or be manipulated as easy-to-understand Ruby objects."
  spec.authors      = ["Sander Hartlage"]
  spec.email        = "sander.hartlage@gmail.com"
  spec.files        = Dir.glob("lib/**/*.rb")
  spec.homepage     = "http://github.com/sander6/chomsky"
end
