class AddOptionalArchiveIdToSessions < ActiveRecord::Migration[8.0]
  def change
    add_column :sessions, :archive_id, :integer
  end
end
