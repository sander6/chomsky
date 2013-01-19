require 'chomsky/parser'

module Chomsky
  class Parser
    class Regexp < Parser
      def initialize pattern
        @pattern = ::Regexp.new("\\A" + pattern.source)
      end

      def call string
        if mdata = @pattern.match(string)
          [mdata.to_s, string[mdata.to_s.length..-1]]
        else
          [nil, string]
        end
      end
    end
  end
end
