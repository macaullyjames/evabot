class CreateJoinTableTeamRepo < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Teams, :Repos do |t|
      # t.index [:team_id, :repo_id]
      # t.index [:repo_id, :team_id]
    end
  end
end
