module SyncableUser
  extend ActiveSupport::Concern

  def sync(by:, as: self)
    orgs.sync by: by, as: as
    repos.sync by: by, as: as
  end

  class_methods do
    def sync(by:, as:)
      all.each { |u| u.sync by: by, as: as }
    end
  end
end
