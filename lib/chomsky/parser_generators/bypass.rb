require 'chomsky'

module Chomsky
  class ParserGenerator
    class Bypass < ParserGenerator
      def initialize left, right
        @left, @right = left, right
      end

      def call string
        head, rest = @left.(string)
        if head
          more = @right.(head)
          if more
            [head, rest]
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
