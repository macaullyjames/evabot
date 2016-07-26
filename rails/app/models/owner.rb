class Owner < ApplicationRecord
  belongs_to :ownerable, polymorphic: true

  def login
    ownerable.login
  end
end
