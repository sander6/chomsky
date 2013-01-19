require 'chomsky'

module Chomsky
  class ParserGenerator
    class Capture < ParserGenerator
      attr_reader :parser

      def initialize
        @parser = nil
      end

      def call string
        @parser = Parser::Literal.(string)
        [string, ""]
      end
    end
  end
end
