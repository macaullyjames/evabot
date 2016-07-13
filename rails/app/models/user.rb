class User < ApplicationRecord
  has_many :repos

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

  def self.from_token token
    user = User.find_by token: token
    user ||= begin
      remote_user = Octokit::Client.new(access_token: token).user
      User.create token: token, username: remote_user.login
    rescue Octokit::Unauthorized
    end
  end
end
