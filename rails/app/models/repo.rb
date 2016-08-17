class Repo < ApplicationRecord
  belongs_to :owner
  has_many :branches
  has_many :team_permissions
  has_many :teams, through: :team_permissions

  def url
    "https://github.com/#{full_name}"
  end

  def full_name
    "#{owner.login}/#{name}"
  end

  def files(pull: true)
    dir = Rails.root.join("repos", owner.login, name).to_s
    if not File.directory?(dir)
      FileUtils.mkdir_p dir
      `git clone #{url}.git #{dir}`
    elsif pull
      Dir.chdir(dir) { `git pull` }
    end
    return Dir[dir]
  end
end
