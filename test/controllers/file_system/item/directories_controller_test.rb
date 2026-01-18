require "test_helper"

class FileSystem::Item::DirectoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @directory = file_system_item_directories(:protagonist_archive_checking_account_file_system_bounties_directory)
  end

  test "should get show" do
    get file_system_item_directory_url(@directory)
    assert_response :success
  end
end
