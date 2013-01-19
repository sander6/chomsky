require 'chomsky'

module Chomsky
  class Parser
    class Anything < Parser
      attr_reader :length

      def initialize length = 1
        @length = length
      end

      def call string
        if string.length < @length
          [nil, string]
        else
          [string[0,@length], string[@length..-1]]
        end
      end
    end
  end
end
