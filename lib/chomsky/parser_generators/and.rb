require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class And < ParserGenerator
      def initialize left, right
        @left, @right = left, right
      end

      def call string
        head, rest = @left.(string)
        if head
          more, rest = @right.(rest)
          if more
            [head + more, rest]
          else
            [nil, string]
          end
        else
          [nil, string]
        end
      end
    end
  end
end
