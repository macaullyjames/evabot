class User < ApplicationRecord
  has_many :repos

  def self.from_code code
    url = "https://github.com/login/oauth/access_token"
    response = RestClient.post url,
      {
        client_id: Rails.application.secrets.github_client_id,
        client_secret: Rails.application.secrets.github_client_secret,
        code: code
      },
      accept: :json
    token = JSON.parse(response.body)["access_token"]
    from_token token
  rescue
    nil
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
