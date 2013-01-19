require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Peek < ParserGenerator
      def call string
        head, rest = @parser.(string)
        if head
          ["", string]
        else
          [nil, string]
        end
      end
    end
  end
end
