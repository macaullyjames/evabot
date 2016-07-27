class RemoveUserFromRepos < ActiveRecord::Migration[5.0]
  def change
    remove_reference :repos, :user, foreign_key: true
  end
end
