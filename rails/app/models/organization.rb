class Organization < ApplicationRecord
  has_one :owner, as: :ownerable
end
