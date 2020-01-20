module Mavenlink
  class TimeEntry < Model
    def association_load_filters
      {
        from_archived_workspaces: true
      }
    end
  end
end
