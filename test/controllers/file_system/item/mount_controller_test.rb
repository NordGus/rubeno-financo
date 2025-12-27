require "test_helper"

class FileSystem::Item::MountControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get file_system_item_mount_show_url
    assert_response :success
  end
end
