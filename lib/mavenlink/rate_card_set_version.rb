module Mavenlink
  class RateCardSetVersion < Model
    def publish!
      raise Mavenlink::Error, "Record not defined" unless persisted?

      client.put("rate_card_set_versions/#{@id}/publish")
    end

    def clone_version(effective_date = nil)
      clone_version!(effective_date)
    rescue Mavenlink::RecordInvalidError, Mavenlink::Error
      false
    end

    def clone_version!(effective_date = nil)
      raise Mavenlink::RecordInvalidError, self unless persisted?

      request.perform do
        client.post(
          collection_name,
          clone_id: id,
          rate_card_set_version: {
            rate_card_set_id: rate_card_set_id,
            effective_date: effective_date
          }
        )
      end.results.first
    end
  end
end
