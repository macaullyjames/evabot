class Repo < ApplicationRecord
  belongs_to :user
  has_many :branches
  has_many :team_permissions
  has_many :teams, through: :team_permissions

  def url
    "https://github.com/#{full_name}"
  end

  def full_name
    "#{owner_name}/#{name}"
  end

end
