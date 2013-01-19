require 'chomsky'

module Chomsky
  class Parser
    autoload :Anything,     "chomsky/parsers/anything"
    autoload :BasicParsers, "chomsky/parsers/basic_parsers"
    autoload :Blank,        "chomsky/parsers/blank"
    autoload :Literal,      "chomsky/parsers/literal"
    autoload :Nothing,      "chomsky/parsers/nothing"
    autoload :Regexp,       "chomsky/parsers/regexp"

    include ParserGenerator::Combinators

    def self.call *args
      new(*args)
    end

    def initialize
    end

    def call string
      [nil, string]
    end

    def to_pg
      self
    end
  end
end
