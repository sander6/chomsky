require 'chomsky'

module Chomsky
  class Action < ParserGenerator
    def initialize grammar, action
      @grammar = grammar
      @action = action
    end

    def call string
      @grammar.instance_exec(string, &@action)
      [string, ""]
    end
  end
end
