# frozen_string_literal: true

module Mavenlink
  module SubscribedEvents
    class Diff
      class List
        MISSING_FIELDS_MESSAGE = "Subscribed events must include optional fields `previous_payload` and `current_payload`"

        def initialize(events)
          @events = events

          # Validate events include optional fields for `current_payload,previous_payload` like in diff
          raise ArgumentError, MISSING_FIELDS_MESSAGE if missing_required_fields?
        end

        def grouped_diffs
          subject_diffs + subject_custom_field_diffs
        end

        private

        attr_reader :events

        def subject_diffs
          grouped_subject_events.each_with_object([]) do |(_key, grouped_events), array|
            array << Mavenlink::SubscribedEvents::Diff.from_collection(grouped_events)
          end
        end

        def subject_custom_field_diffs
          grouped_subject_custom_field_events.each_with_object([]) do |(_key, grouped_events), array|
            array << Mavenlink::SubscribedEvents::Diff.from_collection(grouped_events)
          end
        end

        def grouped_subject_events
          subject_events.group_by { |event| [event.subject_type, event.subject_id] }
        end

        def grouped_subject_custom_field_events
          subject_custom_field_events.group_by { |event| [event.subject_type, event.subject_id, event.current_payload[:custom_field_id]] }
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

        def missing_required_fields?
          events.any? { |event| !event.key?(:previous_payload) || !event.key?(:current_payload) }
        end
      end
    end
  end
end
