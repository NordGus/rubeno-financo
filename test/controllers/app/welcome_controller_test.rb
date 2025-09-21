require "test_helper"

class App::WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get app_welcome_index_url
    assert_response :success
  end
end
