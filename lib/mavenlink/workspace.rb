module Mavenlink
  class Workspace < Model
    validates :title, presence: true
    validates :creator_role, inclusion: {in: %w(maven buyer), allow_blank: true}, on: :update
    # validates :due_date, format: 'YYYY-MM-DD'
    # ...

    # @todo Raise argument errors...
    # @todo Return invitation model?
    # @param invitation [Hash]
    # @option invitation [String] :full_name (required) the full name of the person being invited
    # @option invitation [String] :email_address (required) the email address of the person being invited
    # @option invitation [String] :invitee_role (required) the role for the invited user, either __maven__ (consultant role) or __buyer__ (client role)
    # @option invitation [String] :subject (optional) the subject message of the invitation email
    # @option invitation [String] :message (optional) the text content of the invitation email; if you don't provide this, your default will be used
    def invite(invitation)
      Mavenlink.client.post('workspaces/2/invite', invitation: invitation)
    end
  end
end