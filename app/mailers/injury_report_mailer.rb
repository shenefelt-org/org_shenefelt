class InjuryReportMailer < ApplicationMailer

  def new_report(injury_report)
    @injury_report = injury_report

    mail(
      reply_to: @injury_report.email,
      subject: "Injury Report: #{@injury_report.injured_person} (#{@injury_report.severity.presence || 'unspecified'})"
    )
  end
end
