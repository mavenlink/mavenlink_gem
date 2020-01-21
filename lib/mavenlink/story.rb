module Mavenlink
  class Story < Model
    validates :title, :story_type, :workspace_id, presence: true
    validates :story_type, inclusion: { in: %w[task deliverable milestone issue] }

    def association_load_filters
      {
        show_archived: true,
        show_deleted: true,
        show_from_archived_workspaces: true
      }
    end
  end
end
