require "test_helper"

class App::WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_redirected_to new_session_url
  end
end
