require 'chomsky/parser_generator'

module Chomsky
  class Rule < ParserGenerator
    attr_reader :name

    def initialize grammar, pg
      @grammar = grammar
      @pg = pg
    end

    def call string
      if parser = @grammar.instance_exec(&@pg)
        tok, rest = parser.(string)
        if tok
          [tok, rest]
        else
          [nil, string]
        end
      else
        [nil, string]
      end
    end
  end
end
