class Owner < ApplicationRecord
  belongs_to :ownerable, polymorphic: true
end
