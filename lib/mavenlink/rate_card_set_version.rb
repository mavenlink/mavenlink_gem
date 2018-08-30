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
  end
end
