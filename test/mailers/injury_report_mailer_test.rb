require "test_helper"

class InjuryReportMailerTest < ActionMailer::TestCase
  test "new_report" do
    injury_report = InjuryReport.new(
      name: "Jane Doe",
      email: "jane@example.com",
      injured_person: "John Doe",
      incident_date: Date.new(2026, 8, 26),
      location: "Main office",
      description: "John slipped near the main office entrance.",
      severity: "serious"
    )

    mail = InjuryReportMailer.new_report(injury_report)

    assert_equal "Injury Report: John Doe (serious)", mail.subject
    assert_equal [ "greg@shenefelt.org" ], mail.to
    assert_equal [ "jane@example.com" ], mail.reply_to
    assert_equal [ "greg@shenefelt.org" ], mail.from
    assert_match "John Doe", mail.body.encoded
  end
end
