module Mavenlink
  class EstimateScenario < Model
    validates :name, presence: true, length: { maximum: 255 }
    validates :start_date, presence: true
  end
end
