class User < ApplicationRecord
  include SyncableUser

  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :teams
  has_one :owner, as: :ownerable

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

  def orgs
    organizations
  end

  def repos(permission: :owner)
    repos = owner.repos
    unless permission == :owner
      repos += teams.flat_map { |t| t.repos permission: permission }
    end
    return repos
  end

  after_create do
    owner = Owner.where(ownerable: self).first_or_create
  end
end
