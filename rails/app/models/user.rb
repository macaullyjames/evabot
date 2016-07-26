class User < ApplicationRecord
  has_many :repos
  has_one :owner, as: :ownerable

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

end
