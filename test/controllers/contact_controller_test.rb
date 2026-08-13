require "test_helper"

class ContactControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "there is an index route" do
    get new_contact_url

    assert_response :success

    # check for form tag
    assert_select "form"
  end
end
