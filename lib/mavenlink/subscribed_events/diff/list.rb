module Mavenlink
  module SubscribedEvents
    class Diff
      class List
        def initialize(events)
          @events = events

          # Validate events include optional fields for `current_payload,previous_payload` like in diff
        end

        def grouped_diffs
          subject_diffs + subject_custom_field_diffs
        end

        private

        attr_reader :events

        def subject_diffs
          subject_events.group_by do |event|
            [event.subject_type, event.subject_id]
          end.each_with_object([]) do |(key, grouped_events), array|
            array << Mavenlink::SubscribedEvents::Diff.from_collection(grouped_events)
          end
        end

        def subject_custom_field_diffs
          subject_custom_field_events.group_by do |event|
            [event.subject_type, event.subject_id, event.current_payload[:custom_field_id]]
          end.each_with_object([]) do |(key, grouped_events), array|
            array << Mavenlink::SubscribedEvents::Diff.from_collection(grouped_events)
          end
        end

        def subject_events
          events.reject { |event| custom_field_event?(event.event_type) }
        end

        def subject_custom_field_events
          events.select { |event| custom_field_event?(event.event_type) }
        end

        def custom_field_event?(event_type)
          event_type.include?(":custom_field_value_")
        end
      end
    end
  end
end
