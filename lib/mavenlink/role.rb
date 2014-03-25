module Mavenlink
  class Role < Model # TODO(SZ): remove
    include Concerns::LockedRecord
  end
end