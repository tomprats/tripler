class Feedback < ActiveRecord::Base
  def self.default_scope
    where(deleted: false)
  end
end
