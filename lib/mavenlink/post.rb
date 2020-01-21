module Mavenlink
  class Post < Model
    def association_load_filters
      {
        from_archived_workspaces: true
      }
    end
  end
end
