class AddOwnerableToOwner < ActiveRecord::Migration[5.0]
  def change
    add_reference :owners, :ownerable, polymorphic: true
  end
end
