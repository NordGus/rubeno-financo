class RemoveAttemptedAccessCountFromPasswordKeys < ActiveRecord::Migration[8.0]
  def change
    remove_column :password_keys, :attempted_access_count, :integer, if_exists: true
  end
end
