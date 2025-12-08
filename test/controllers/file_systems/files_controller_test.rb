require "test_helper"

class FileSystems::FilesControllerTest < ActionDispatch::IntegrationTest
  test "should get attachment" do
    get file_systems_files_attachment_url
    assert_response :success
  end
end
