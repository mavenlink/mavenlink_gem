module Mavenlink
  class Assignment < Model
    validates :story_id, :assignee_id, presence: true, on: :create
  end
end
