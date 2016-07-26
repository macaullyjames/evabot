class AddLoginToOwner < ActiveRecord::Migration[5.0]
  def change
    add_column :owners, :login, :string
  end
end
