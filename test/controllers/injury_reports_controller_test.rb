require "test_helper"

class InjuryReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get injury_reports_new_url
    assert_response :success
  end

  test "should get create" do
    get injury_reports_create_url
    assert_response :success
  end
end
