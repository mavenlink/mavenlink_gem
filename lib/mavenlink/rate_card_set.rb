module Mavenlink
  class RateCardSet < Model
    def clone!(set_version_id, title: nil, include: nil)
      raise Mavenlink::Error.new("Record not defined") unless persisted?

      request.perform do
        client.post(
          collection_name,
          clone_version_id: set_version_id,
          include: include,
          rate_card_set: {
            title: title,
          }
        )
      end.results.first
    end

    def clone(set_version_id, title: nil, include: nil)
      clone!(set_version_id, title: title, include: include)
    rescue Mavenlink::Error
      false
    end
  end
end
