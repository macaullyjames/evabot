class Repo < ApplicationRecord
  belongs_to :user
  has_many :branches

  def url
    "https://github.com/#{full_name}"
  end

  def full_name
    "#{owner}/#{name}"
  end

end
