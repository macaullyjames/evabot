class Repo < ApplicationRecord
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
      if owner == as.login and hook_id.blank?
        hook = as.remote.create_hook(
          full_name,
          "web",
          {
            url: events_url,
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
