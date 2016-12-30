module Mavenlink
  class StoryDependency < Model
    validates :workspace_id, presence: true, on: :create
  end
end
