module Mavenlink
  class User < Model
    include Concerns::CustomFieldable
    include Concerns::LockedRecord
  end
end
