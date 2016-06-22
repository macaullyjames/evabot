require 'octokit'

module Authenticator
    def self.get_username(token)
      Octokit::Client.new(:access_token => token).user.login
    rescue
    end
end
