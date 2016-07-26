class AddLoginToOrganizations < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :login, :string
  end
end
