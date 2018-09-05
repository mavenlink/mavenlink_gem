module Mavenlink
  class RateCardSetVersion < Model
    def publish
      if persisted?
        client.put("rate_card_set_versions/#@id/publish")
        true
      else
        false
      end
    rescue Faraday::Error
      false
    end

    def clone_version(effective_date = nil)
      return false unless persisted?

      request.perform do
        client.post(collection_name, {
          clone_id: self.id,
          rate_card_set_versions: {
            rate_card_set_id: self.rate_card_set_id,
            effective_date: effective_date
          }
        })
      end.results.first
    rescue Mavenlink::Error
      false
    end
  end
end
