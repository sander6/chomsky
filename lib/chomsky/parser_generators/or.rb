require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Or < ParserGenerator
      def initialize left, right
        @left, @right = left, right
      end

      def call string
        head, rest = @left.(string)
        if head
          [head, rest]
        else
          more, rest = @right.(string)
          if more
            [more, rest]
          else
            [nil, string]
          end
        end
      end
    end
  end
end
