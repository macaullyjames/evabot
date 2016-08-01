module SyncableTeam
  extend ActiveSupport::Concern

  def sync(by:, as:)
    repos.sync by: by, as: as, owner: organization.owner
    sync_by_fetching(as) if by == :fetching
  end

  def sync_by_fetching(as)
    remote_repos = as.remote.team_repos remote_id
    remote_repos.each do |r|
      repo = repos.find_by name: r.name 
      permission = TeamPermission.where(
        team: self,
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

  class_methods do
    def sync(by:, as:)
      sync_by_fetching(as) if by == :fetching
      all.each { |t| t.sync by: by, as: as }
    end

    def sync_by_fetching(as)
      as.remote.user_teams.each do |t|
        team = Team.find_by(remote_id: t.id)
        team ||= create(
          organization: Organization.find_by(login: t.organization.login),
          remote_id: t.id,
          slug: t.slug,
          permission: t.permission
        )
        team.users << as
      end
    end
  end
end
