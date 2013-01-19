require 'chomsky'

module Chomsky
  class Grammar
    include Parser::BasicParsers
    include ParserGenerator::Combinators

    def self.rule name, &pg
      define_method(name) { Rule.new(self, pg) }
    end

    def self.action name, &block
      define_method(name) { Action.new(self, block) }
    end

    def initialize
    end

  end
end
