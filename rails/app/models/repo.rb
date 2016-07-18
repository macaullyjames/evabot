class Repo < ApplicationRecord
  belongs_to :user
  has_many :branches

  def url
    "https://github.com/#{owner}/#{name}"
  end

end
