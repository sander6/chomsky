require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Perhaps < ParserGenerator
      def call string
        head, rest = @parser.(string)
        [head || "", rest]
      end
    end
  end
end
