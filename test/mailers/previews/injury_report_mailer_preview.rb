# Preview all emails at http://localhost:3000/rails/mailers/injury_report_mailer
class InjuryReportMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/injury_report_mailer/new_report
  def new_report
    InjuryReportMailer.new_report
  end
end
