class IssueCreationJob < ApplicationJob
  queue_as :default

  def perform(user, repo, *args)
    dir = pull repo, as: user
    check = InvalidJavaCheck.new dir
    unless check.passes? 
      puts check.issue_title
      puts check.issue_message
    end
  end

  def pull(repo, as: user)
    logger.info "Pulling repo #{repo.full_name} as user #{as.login}"
    dir = Rails.root.join("repos", repo.owner.login, repo.name).to_s
    credentials = Rugged::Credentials::UserPassword.new(
      username: as.login,
      password: as.token
    )
    if not File.directory?(dir)
      FileUtils.mkdir_p dir
      Rugged::Repository.clone_at(
        "#{repo.url}.git",
        dir,
        credentials: credentials
      )
    else
      r = Rugged::Repository.new dir
      r.fetch "origin"
      r.checkout(r.branches["origin/master"], strategy: :force)
    end
    return dir
  end
end
