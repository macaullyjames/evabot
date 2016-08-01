class Team < ApplicationRecord
  include SyncableTeam
  belongs_to :organization
  has_and_belongs_to_many :users
  has_many :team_permissions
  has_many :repos, through: :team_permissions

  def sync(by:, as:)
  end

  def self.sync(by:, as:)
  end

end
