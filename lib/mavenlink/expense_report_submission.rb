module Mavenlink
  class ExpenseReportSubmission < Model
    def reject
      client.put("expense_report_submissions/#{self.id}/reject")
    end
  end
end

