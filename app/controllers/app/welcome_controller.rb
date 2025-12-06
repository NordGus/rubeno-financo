# frozen_string_literal: true

class App::WelcomeController < AppController
  def index
    @test_file = FileSystem::Item::File.find_by!(
      name: "Monkey D Luffy.png",
      parentable_type: "FileSystem::Item::Directory",
      archive: Current.archive
    )
  end
end
