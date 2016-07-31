class Organization < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :teams
  has_one :owner, as: :ownerable

  def repos
    owner.repos
  end

  def sync(by:, as: self)
    orgs.sync by: by, as: as
    repos.sync by: by, as: as
    teams.sync by: by, as: as
  end

  def self.sync(by:, as:)
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
