class RemoveLoginFromOwner < ActiveRecord::Migration[5.0]
  def change
    remove_column :owners, :login, :string
  end
end
