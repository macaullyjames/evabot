class AddReferencesToRepos < ActiveRecord::Migration[5.0]
  def change
    add_reference :repos, :branches, foreign_key: true
  end
end
