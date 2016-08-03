class Team < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :users
  has_many :team_permissions
  has_many :repos, through: :team_permissions

  def repos(permission: :admin)
    permissions = [:pull, :push, :admin]
    implied = permissions.drop(permissions.index permission)
    team_permissions.where(permission: implied).map(&:repo)
  end
end
