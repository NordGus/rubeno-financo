require "test_helper"

class FileSystem::Item::MountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mount = file_system_item_mounts(:protagonist_archive_checking_account_file_system)
  end

  test "should get show" do
    get file_system_item_mount_url(@mount)
    assert_response :success
  end
end
