class AddOwnerToRepos < ActiveRecord::Migration[5.0]
  def change
    add_column :repos, :owner, :string
  end
end
