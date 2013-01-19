require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Skip < ParserGenerator
      def call string
        head, rest = @parser.(string)
        if head
          ["", rest]
        else
          [nil, rest]
        end
      end
    end
  end
end

