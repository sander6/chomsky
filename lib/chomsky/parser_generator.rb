require 'chomsky/parser_generators/combinators'

module Chomsky
  class ParserGenerator
    autoload :And,            "chomsky/parser_generators/and"
    autoload :Compose,        "chomsky/parser_generators/compose"
    autoload :Repeat,         "chomsky/parser_generators/repeat"
    autoload :Not,            "chomsky/parser_generators/not"
    autoload :Or,             "chomsky/parser_generators/or"
    autoload :Peek,           "chomsky/parser_generators/peek"
    autoload :Perhaps,        "chomsky/parser_generators/perhaps"
    autoload :Skip,           "chomsky/parser_generators/skip"
    autoload :Some,           "chomsky/parser_generators/some"
    autoload :Capture,        "chomsky/parser_generators/capture"
    autoload :Backreference,  "chomsky/parser_generators/backreference"

    include Chomsky::ParserGenerator::Combinators

    def self.call *args
      new(*args)
    end

    def initialize parser
      @parser = parser
    end

    def call string
      @parser.call(string)
    end

    def to_pg
      self
    end
  end
end
