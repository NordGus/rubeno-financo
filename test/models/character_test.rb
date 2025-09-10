require "test_helper"

class CharacterTest < ActiveSupport::TestCase
  test "#replace_padlock!" do
    character = characters(:one)

    previous_padlock_version = character.padlock_version

    character.replace_padlock!

    assert character.padlock_version != previous_padlock_version, "padlock_version did not changed"
  end
end
