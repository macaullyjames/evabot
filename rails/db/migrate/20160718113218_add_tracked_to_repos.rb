class AddTrackedToRepos < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :tracked, :boolean
  end
end
