class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.integer :remote_id
      t.string :name
      t.string :slug
      t.string :permission
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
