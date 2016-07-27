class RenameReposTeams < ActiveRecord::Migration[5.0]
  def change
    rename_table :repos_teams, :team_permissions
  end
end
