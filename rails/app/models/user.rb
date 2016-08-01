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

  def repos
    owner.repos
  end

end
