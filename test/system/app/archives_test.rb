require "application_system_test_case"

class App::ArchivesTest < ApplicationSystemTestCase
  setup do
    @app_archive = app_archives(:one)
  end

  test "visiting the index" do
    visit app_archives_url
    assert_selector "h1", text: "Archives"
  end

  test "should create archive" do
    visit app_archives_url
    click_on "New archive"

    click_on "Create Archive"

    assert_text "Archive was successfully created"
    click_on "Back"
  end

  test "should update Archive" do
    visit app_archive_url(@app_archive)
    click_on "Edit this archive", match: :first

    click_on "Update Archive"

    assert_text "Archive was successfully updated"
    click_on "Back"
  end

  test "should destroy Archive" do
    visit app_archive_url(@app_archive)
    click_on "Destroy this archive", match: :first

    assert_text "Archive was successfully destroyed"
  end
end
