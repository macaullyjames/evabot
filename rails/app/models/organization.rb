class Organization < ApplicationRecord
  include SyncableOrganization
  has_and_belongs_to_many :users
  has_many :teams
  has_one :owner, as: :ownerable

  def repos
    owner.repos
  end

end
