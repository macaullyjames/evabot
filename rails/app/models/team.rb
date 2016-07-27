class Team < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :users
  has_many :team_permissions
  has_many :repos, through: :team_permissions

  def sync(by:, as:)
    if by == :fetching
      remote_repos = as.remote.team_repos remote_id
      repos.each do |repo|
        repo.destroy unless remote_repos.any? do |r|
          r.full_name == repo.full_name
        end
      end
      remote_repos.each do |r|
        repo = Repo.find_by owner: organization.owner, name: r.name 
        repo ||= Repo.create(
          owner: organization.owner,
          name: r.name,
          tracked: false
        )

        remote_permission = begin 
          if r.permissions.admin then :admin
          elsif r.permissions.push then :push
          elsif r.permissions.pull then :pull
          else :none
          end
        end

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
      repos.each { |r| r.sync by: :fetching, as: as }
    end
  end

end
