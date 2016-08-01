module SyncableRepo
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  def sync(by:, as: self)
    sync_by_fetching(as) if by == :fetching
  end

  def sync_by_fetching(as)
    can_hook = (owner == as.owner)
    can_hook ||= teams.find_all{|t| t.users.include? as}.any? do |t|
      TeamPermission.where(team: t, repo: self, permission: :admin).exists? 
    end
    if can_hook
      remote_hooks = as.remote.hooks full_name
      callback_url = events_url host: Rails.configuration.host
      remote_hooks.each do |h|
        if h.config.url == callback_url
          as.remote.remove_hook full_name, h.id
        end
      end
      hook = as.remote.create_hook(
        full_name,
        "web",
        {
          url: callback_url,
          content_type: "json"
        },
        events: [ "*" ],
        active: tracked?
      )
      update hook_id: hook.id
    end
  end

  class_methods do
    def sync(by:, as:, owner:)
      sync_by_fetching(as, owner) if by == :fetching
      all.each { |r| r.sync by: by, as: as }
    end

    def sync_by_fetching(as, owner)
      remote_repos =
        if owner.is_a? User
          as.remote.repos owner.login, affiliation: :owner
        elsif owner.is_a? Organization
          as.remote.org_repos owner.login
        end
      all.each do |repo|
        repo.destroy unless remote_repos.any? do |r|
          r.full_name == repo.full_name
        end
      end
      remote_repos.each do |r|
        repo = Repo.find_by owner: owner.owner, name: r.name 
        repo ||= Repo.create(
          owner: owner.owner,
          name: r.name,
          tracked: false
        )
      end
    end
  end
end
