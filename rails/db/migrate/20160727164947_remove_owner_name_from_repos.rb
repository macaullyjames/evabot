class RemoveOwnerNameFromRepos < ActiveRecord::Migration[5.0]
  def change
    remove_column :repos, :owner_name, :string
  end
end
