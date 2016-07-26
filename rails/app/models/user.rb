class User < ApplicationRecord
  has_many :repos
  has_and_belongs_to_many :organizations

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

  def orgs
    organizations
  end

  def login
    username
  end

end
