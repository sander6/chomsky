require 'chomsky/parser'

module Chomsky
  class Parser
    class Literal < Parser
      def initialize string
        @value = string
      end

      def call string
        if string.start_with?(@value)
          [@value, string[@value.length..-1]]
        else
          [nil, string]
        end
      end
    end
  end
end
