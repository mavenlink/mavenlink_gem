module Mavenlink
  class Expense < Model
    def association_load_filters
      {
        from_archived_workspaces: true
      }
    end
  end
end
