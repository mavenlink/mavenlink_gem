module Mavenlink
  class Story < Model
    include Concerns::CustomFieldable

    validates :title, :story_type, :workspace_id, presence: true
    validates :story_type, inclusion: { in: %w[task deliverable milestone issue] }
  end
end