require "test_helper"

class FileSystem::Item::FilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @file = file_system_item_files(:protagonist_archive_checking_account_file_system_luffy_bounty_file_fourth_version)
  end

  test "should get attachment" do
    get file_system_item_file_url(@file)
    assert_response :success
  end
end
