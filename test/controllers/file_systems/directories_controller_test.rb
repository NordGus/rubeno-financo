require "test_helper"

class FileSystems::DirectoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get file_systems_directories_show_url
    assert_response :success
  end
end
