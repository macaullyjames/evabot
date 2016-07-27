class AddIdToTeamPermissions < ActiveRecord::Migration[5.0]
  def change
    add_column :team_permissions, :id, :primary_key
  end
end
