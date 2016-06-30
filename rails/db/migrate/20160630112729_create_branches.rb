class CreateBranches < ActiveRecord::Migration[5.0]
  def change
    create_table :branches do |t|
      t.references :repo, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
