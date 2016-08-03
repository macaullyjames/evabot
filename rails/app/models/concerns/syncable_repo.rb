module SyncableRepo
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  def sync(by:, as:)
    sync_by_fetching(as) if by == :fetching
  end

  def sync_by_fetching(as)
    if as.repos(permission: :admin).include? self
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
        if owner.ownerable.is_a? User
          as.remote.repos owner.login, affiliation: :owner
        elsif owner.ownerable.is_a? Organization
          as.remote.org_repos owner.login
        end
      all.each do |repo|
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
  end
end
