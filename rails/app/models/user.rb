class User < ApplicationRecord
  has_many :repos

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

  def login
    username
  end

end
