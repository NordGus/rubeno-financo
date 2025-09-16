require "test_helper"

class FirstRunsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get first_runs_show_url
    assert_response :success
  end

  test "should get create" do
    get first_runs_create_url
    assert_response :success
  end
end
