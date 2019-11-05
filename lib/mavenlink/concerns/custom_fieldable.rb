module Mavenlink
  module Concerns
    module CustomFieldable
      def custom_field_values
        client.custom_field_values.filter(subject_type: collection_name.singularize, with_subject_id: id)
      end
    end
  end
end
