module Syncable
  extend ActiveSupport::Concern

  def sync(by:, as: default_syncer)
    self.class.reflect_on_all_associations.each do |a|
      method = "sync_#{a.name}_by_#{by}".to_sym
      send(method, as) if respond_to? method
    end
  end

  def default_syncer
    if is_a? User then self
    elsif is_a? Organization then users.sample
    elsif is_a? Team then users.sample
    elsif is_a? Repo then owner.default_syncer
    end
  end

end
