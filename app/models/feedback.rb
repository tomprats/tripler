class Feedback < ActiveRecord::Base
  validates_presence_of :name, :email, :message

  def self.default_scope
    where(deleted: false)
  end
end
