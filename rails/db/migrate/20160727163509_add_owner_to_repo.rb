class AddOwnerToRepo < ActiveRecord::Migration[5.0]
  def change
    add_reference :repos, :owner, foreign_key: true
  end
end
