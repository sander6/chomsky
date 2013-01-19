require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Not < ParserGenerator
      def call string
        head, rest = @parser.(string)
        if head
          [nil, string]
        else
          ["", rest]
        end
      end
    end
  end
end
