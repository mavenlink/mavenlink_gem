module Mavenlink
  class Invoice < Model
    include Concerns::LockedRecord
  end
end