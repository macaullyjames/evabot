class ChangeRepoOwnerToOwnerName < ActiveRecord::Migration[5.0]
  def change
    rename_column :repos, :owner, :owner_name
  end
end
