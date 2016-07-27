class AddPermissionToReposTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :repos_teams, :permission, :string
  end
end
