# frozen_string_literal: true

module Mavenlink
  module SubscribedEvents
    class Diff
      extend Forwardable

      BAD_COLLECTION_MESSAGE = "Expected an array of subscribed events of the same subject_type"
      MISSING_FIELDS_MESSAGE = "Subscribed events must include optional fields `previous_payload` and `current_payload`"
      SUBJECT_MISMATCH_MESSAGE = "Subscribed events must belong to the same subject"

      def_delegators :to_h, :[], :dig

      def self.from_collection(subscribed_events)
        subscribed_events = Array.wrap(subscribed_events)

        raise ArgumentError, BAD_COLLECTION_MESSAGE if subscribed_events.any? { |event| !event.is_a?(Mavenlink::SubscribedEvent) }

        events = subscribed_events.sort { |a, b| a.subject_changed_at.to_datetime <=> b.subject_changed_at.to_datetime }

        new(events.first, events.last)
      end

      def initialize(event_a, event_b)
        ordered_events = [event_a, event_b].sort { |a, b| a.subject_changed_at.to_datetime <=> b.subject_changed_at.to_datetime }

        @first = ordered_events.first
        @last = ordered_events.last

        raise ArgumentError, MISSING_FIELDS_MESSAGE if missing_required_fields?
        raise ArgumentError, SUBJECT_MISMATCH_MESSAGE if subject_differs?
      end

      # NOTE: Add subscribed event subject association to hash once available
      def to_h
        {
          subject_type: first.subject_type,
          subject_id: first.subject_id,
          subject_first_changed_at: first.subject_changed_at,
          subject_last_changed_at: last.subject_changed_at,
          last_user_id: last.user_id,
          last_event_type: last.event_type,
          payload_changes: payload_changes,
          previous_payload: first.previous_payload,
          current_payload: last.current_payload
        }.with_indifferent_access
      end

      private

      attr_reader :first, :last

      def missing_required_fields?
        !first.key?(:previous_payload) || !last.key?(:current_payload)
      end

      def subject_differs?
        first.subject_type != last.subject_type || first.subject_id != last.subject_id
      end

      def payload_changes
        first.previous_payload.each_with_object({}) do |(key, value), hash|
          hash[key.to_sym] = { from: value, to: last.current_payload[key] } if value != last.current_payload[key]
        end
      end
    end
  end
end
