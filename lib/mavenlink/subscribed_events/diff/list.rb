module Mavenlink
  module SubscribedEvents
    class Diff
      class List
        def initialize(events)
          @events = events
        end

        def grouped_diffs
        end

        private

        attr_reader :events
      end
    end
  end
end
