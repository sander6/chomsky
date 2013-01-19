require 'chomsky'

module Chomsky
  class ParserGenerator
    class Backreference < ParserGenerator
      def initialize capture
        @capture = capture
      end

      def call string
        if parser = @capture.parser
          parser.(string)
        else
          [nil, string]
        end
      end
    end
  end
end
