require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Repeat < ParserGenerator
      def initialize parser, n
        super(parser)
        @n = n
      end

      def call string
        head, rest = "", string
        @n.times do
          more, rest = @parser.(rest)
          if more
            head += more
          else
            return [nil, string]
          end
        end
      end
    end
  end
end
