require 'chomsky'

module Chomsky
  class Parser
    class Blank < Regexp
      def initialize
        super(%r{\s+})
      end
    end
  end
end
