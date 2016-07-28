module Syncable
  extend ActiveSupport::Concern

  def sync(by:, as: self)
    self.class.reflect_on_all_associations.each do |a|
      fetch_method = "sync_#{a.name}_by_#{by}".to_sym
      if respond_to? fetch_method
        send fetch_method, as
      end
    end
  end

  def sync_organizations_by_fetching(as)
    remote_orgs = as.remote.orgs
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
  end

  def sync_repos_by_fetching(as)
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
    repos.each { |r| r.sync by: :fetching, as: self }
  end

  def sync_teams_by_fetching(as)
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
    teams.each { |t| t.sync by: :fetching, as: self }
  end

end
