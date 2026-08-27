# Preview all emails at http://localhost:3000/rails/mailers/injury_report_mailer
class InjuryReportMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/injury_report_mailer/new_report
  def new_report
    InjuryReportMailer.new_report(
      InjuryReport.new(
        name: "Jane Doe",
        email: "jane@example.com",
        injured_person: "John Doe",
        incident_date: Date.current,
        location: "Main office",
        description: "John slipped near the main office entrance.",
        severity: "serious"
      )
    )
  end
end
