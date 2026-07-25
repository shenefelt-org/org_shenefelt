require "test_helper"

class TokenControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get token_new_url
    assert_response :success
  end

  test "should get create" do
    get token_create_url
    assert_response :success
  end
end
