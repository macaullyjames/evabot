module SyncableOrganization
  extend ActiveSupport::Concern

  def sync(by:, as:)
    repos.sync by: by, as: as, owner: owner
    teams.sync by: by, as: as
  end

  class_methods do
    def sync(by:, as:)
      sync_by_fetching(as) if by == :fetching
      all.each { |o| o.sync by: by, as: as }
    end

    def sync_by_fetching(as)
      remote_orgs = as.remote.orgs
      remote_orgs.each do |o|
        org = Organization.where(login: o.login).first_or_create
        org.users << as
        Owner.where(ownerable: org).first_or_create
      end
      all.each do |org|
        org.destroy unless remote_orgs.any? do |o|
          o.login == org.login
        end
      end
    end
  end
end
