class Team < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :users
  has_many :repos, through: :team_permissions
end
