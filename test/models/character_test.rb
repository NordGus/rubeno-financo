require "test_helper"

class CharacterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "#replace_all_locks!" do
    character = characters(:one)

    previous_keys_version = character.keys_version

    character.replace_all_locks!

    assert character.keys_version != previous_keys_version, "keys_version did not changed"
  end
end
