module OauthHelper
  def oauth_signup_url 
    params = {
      client_id: Rails.application.secrets.github_client_id,
      scope: "email repo admin:org admin:repo_hook"
    }
    return "https://github.com/login/oauth/authorize?#{params.to_query}"
  end
end

