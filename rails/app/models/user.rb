class User < ApplicationRecord

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

  def sync(by:, as: self)
    orgs.sync by: by, as: as
    repos.sync by: by, as: as
    teams.sync by: by, as: as
  end

  def self.sync(by:, as:)
    all.each { |u| u.sync by: by, as: as }
  end

end
