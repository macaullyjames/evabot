class Repo < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :owner
  has_many :branches
  has_many :team_permissions
  has_many :teams, through: :team_permissions

  def url
    "https://github.com/#{full_name}"
  end

  def full_name
    "#{owner.login}/#{name}"
  end

  def sync(by:, as:)
    if by == :fetching
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
  end
end
