require 'chomsky'

module Chomsky
  class Action < ParserGenerator
    def initialize grammar, action
      @grammar = grammar
      @action = action
    end

    def call value
      @grammar.instance_exec(value, &@action)
    end
  end
end
