class CreateJoinTableUserOrganization < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Users, :Organizations do |t|
      # t.index [:user_id, :organization_id]
      # t.index [:organization_id, :user_id]
    end
  end
end
