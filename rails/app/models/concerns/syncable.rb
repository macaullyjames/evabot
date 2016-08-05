module Syncable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  def sync
    sync_orgs
    sync_user_repos
    sync_org_repos
    sync_teams
  end

  def sync_orgs
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
  end

  def sync_user_repos
    remote_repos = remote.repos owner.login, affiliation: :owner
    remote_repos.each do |r|
      repo = Repo.find_by owner: owner, name: r.name 
      repo ||= Repo.create(
        owner: owner,
        name: r.name,
        tracked: false
      )
    end
    repos.each do |repo|
      repo.destroy unless remote_repos.any? do |r|
        r.full_name == repo.full_name
      end
    end
  end

  def sync_org_repos
    orgs.each do |org|
      remote_repos = remote.org_repos org.owner.login
      org.repos.each do |repo|
        repo.destroy unless remote_repos.any? do |r|
          r.full_name == repo.full_name
        end
      end
      remote_repos.each do |r|
        repo = Repo.find_by owner: org.owner, name: r.name 
        repo ||= Repo.create(
          owner: org.owner,
          name: r.name,
          tracked: false
        )
      end
    end
  end

  def sync_teams
    remote.user_teams.each do |t|
      team = Team.find_by(remote_id: t.id)
      team ||= Team.create(
        organization: Organization.find_by(login: t.organization.login),
        remote_id: t.id,
        slug: t.slug,
        permission: t.permission
      )
      team.users << self

      remote_repos = remote.team_repos team.remote_id
      remote_repos.each do |r|
        repo = Repo.find_by owner: team.organization.owner, name: r.name 
        permission = TeamPermission.where(
          team: team,
          repo: repo
        ).first_or_create
        permission.update permission: begin 
          if r.permissions.admin then :admin
          elsif r.permissions.push then :push
          elsif r.permissions.pull then :pull
          else :none
          end
        end
      end
    end
  end

end
