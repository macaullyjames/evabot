class RemoveReposFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :users, :repos, foreign_key: true
  end
end
