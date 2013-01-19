require 'chomsky'

module Chomsky
  class Parser
    class Nothing < Parser
      def call string
        if string.empty?
          ["", string]
        else
          [nil, string]
        end
      end
    end
  end
end
