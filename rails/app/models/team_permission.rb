class TeamPermission < ApplicationRecord
  belongs_to :team
  belongs_to :repo
end
