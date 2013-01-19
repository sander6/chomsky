require 'chomsky/parser'
require 'chomsky/parser_generators/perhaps'

module Chomsky
  class Parser
    module BasicParsers
      # Any single character
      def _
        Anything.()
      end

      # Only matches an empty string
      def eos
        Nothing.()
      end

      # Matches one or more whitespace characters
      def ___
        Blank.()
      end

      # optional whitespace
      def ___?
        ParserGenerator::Perhaps.(Blank.())
      end

      def ` string
        Literal.(string)
      end

      def r regexp
        Parser::Regexp.(regexp)
      end
    end
  end
end
