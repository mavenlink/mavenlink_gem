module Mavenlink
  class User < Model
    include Concerns::LockedRecord
  end
end
