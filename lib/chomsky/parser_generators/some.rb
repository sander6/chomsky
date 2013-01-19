require 'chomsky/parser_generator'

module Chomsky
  class ParserGenerator
    class Some < ParserGenerator
      def call string
        head, rest = @parser.(string)
        if head
          more = ""
          until more.nil?
            more, rest = @parser.(rest)
            head += more if more
          end
          [head, rest]
        else
          [nil, string]
        end
      end
    end
  end
end
