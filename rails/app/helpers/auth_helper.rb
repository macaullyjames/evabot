module AuthHelper

  def authorization_url
    params = {
      client_id: Rails.application.secrets.github_client_id,
      redirect_uri: auth_callback_url,
      scope: "email repo admin:org admin:repo_hook"
    }
    "https://github.com/login/oauth/authorize?#{params.to_query}"
  end

  # Exchange an authentication code for an access token as part of Github's
  # OAuth authorization code grant flow.
  def token_from auth_code
    url = "https://github.com/login/oauth/access_token"
    params = {
      client_id: Rails.application.secrets.github_client_id,
      client_secret: Rails.application.secrets.github_client_secret,
      code: auth_code
    }
    response = RestClient.post url, params, :accept => :json
    JSON.parse(response.body)["access_token"]
  end

  # Get a user from the given OAuth access token. If no such user exists, one
  # will be created (provided that the token is valid).
  def user_from token
    user = User.find_by token: token
    user ||= begin
      username = Octokit::Client.new(:access_token => token).user.login
      User.create username: username, token: token
    end
  end
end
