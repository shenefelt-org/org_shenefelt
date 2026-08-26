require "test_helper"

class InjuryReportMailerTest < ActionMailer::TestCase
  test "new_report" do
    mail = InjuryReportMailer.new_report
    assert_equal "New report", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
