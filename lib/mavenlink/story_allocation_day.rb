module Mavenlink
  class StoryAllocationDay < Model
    validates :assignment_id, :date, :minutes, presence: true
  end
end
