class AddHookIdToRepos < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :hook_id, :int
  end
end
