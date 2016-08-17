class IssueCreationJob < ApplicationJob
  queue_as :default

  def perform(regex, *args)
    repos = Repo.where "name  REGEXP ?", regex
    repos.each do |repo|
      repo.pull
      checks = [
        #NonEmptyCheck repo,
        #SpellingCheck repo,
        InvalidJavaCheck repo
      ]
      checks.reject! &:passed
      checks[0..5].each do |check|
        check.create_issue
      end
    end
  end
end
