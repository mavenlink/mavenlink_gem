module Mavenlink
  class ExpenseReportSubmission < Model
    def approve_submission
      client.put("expense_report_submissions/#{id}/approve")
    end

    def reject_submission
      client.put("expense_report_submissions/#{id}/reject")
    end
  end
end
