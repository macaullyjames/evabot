class Owner < ApplicationRecord
  belongs_to :ownerable, polymorphic: true
  has_many :repos

  def login
    ownerable.login
  end
end
