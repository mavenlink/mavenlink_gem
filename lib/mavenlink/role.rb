module Mavenlink
  class Role < Model
    include Concerns::LockedRecord
  end
end