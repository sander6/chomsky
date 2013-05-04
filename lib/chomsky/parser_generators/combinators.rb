require 'chomsky'

module Chomsky
  class ParserGenerator
    module Combinators
      def !
        Not.(self.to_pg)
      end

      def _?
        Perhaps.(self.to_pg)
      end

      def & other
        Sequence.(self.to_pg, other.to_pg)
      end

      def | other
        Or.(self.to_pg, other.to_pg)
      end

      def < other
        Skip.(self.to_pg) & other.to_pg
      end

      def > other
        self.to_pg & Skip.(other.to_pg)
      end

      def % other
        self.to_pg & Peek.(other.to_pg)
      end

      def - other
        self.to_pg >> !(other.to_pg)
      end

      def +
        Some.(self.to_pg)
      end

      def *
        self.+()._?
      end

      def [] min, max = nil
        if max
          p = Repeat.(self._?, max)
          min ? Repeat.(self.to_pg, min) & p : p
        else
          case min
          when 0
            self.*()
          when 1
            self.+()
          else
            Repeat.(self.to_pg, min) & self._?.*()
          end
        end
      end

      def >> other
        Compose.(self.to_pg, other.to_pg)
      end

      def capture name
        captures[name] = Capture.new
      end
      alias_method :cap, :capture

      def reference name
        Backreference.new(captures[name])
      end
      alias_method :ref, :reference

      private

      def captures
        @captures ||= {}
      end
    end
  end
end
