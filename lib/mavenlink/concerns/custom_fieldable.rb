module Mavenlink
  module Concerns
    module CustomFieldable
      def custom_field_values
        client.custom_field_values.filter(subject_type: self.collection_name.singularize, with_subject_id: self.id)
      end
    end
  end
end
