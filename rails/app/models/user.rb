class User < ApplicationRecord
  has_many :repos

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

  def self.from_token token
    User.find_by(token: token) || begin
      remote = Octokit::Client.new access_token: token
      user = User.create token: token, username: remote.user.login

      remote.repositories.each do |repo|
        if repo.permissions.admin
          Repo.create name: repo.name,
            user_id: user.id,
            owner: repo.owner.login
        end
      end

      user
    rescue Octokit::Unauthorized
    end
  end
end
