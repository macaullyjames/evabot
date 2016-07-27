class User < ApplicationRecord
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :teams
  has_one :owner, as: :ownerable

  def remote
    client = Octokit::Client.new access_token: token
    client if client.user
  rescue Octokit::Unauthorized
  end

  def orgs
    organizations
  end

  def repos
    owner.repos
  end

  def sync(by:)
    if by == :fetching
      remote_orgs = remote.orgs
      remote_orgs.each do |o|
        org = Organization.where(login: o.login).first_or_create
        org.users << self
        Owner.where(ownerable: org).first_or_create
      end
      orgs.each do |org|
        org.destroy unless remote_orgs.any? do |o|
          o.login == org.login
        end
      end

      remote_repos = remote.repos nil, affiliation: :owner
      repos.each do |repo|
        repo.destroy unless remote_repos.any? do |r|
          r.full_name == repo.full_name
        end
      end
      remote_repos.each do |r|
        repo = Repo.find_by owner: owner, name: r.name 
        repo ||= Repo.create(
          owner: owner,
          name: r.name,
          tracked: false
        )
      end
    end

    remote.user_teams.each do |t|
      team = Team.find_by(remote_id: t.id)
      team ||= Team.create(
        organization: Organization.find_by(login: t.organization.login),
        remote_id: t.id,
        slug: t.slug,
        permission: t.permission
      )
      team.users << self
    end
  end

end
