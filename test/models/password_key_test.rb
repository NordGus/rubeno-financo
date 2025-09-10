require "test_helper"

class PasswordKeyTest < ActiveSupport::TestCase
  test "#replace_key!" do
    password = password_keys(:one)

    previous_key_version = password.key_version

    password.replace_key!

    assert password.key_version != previous_key_version, "key_version did not changed"
  end
end
