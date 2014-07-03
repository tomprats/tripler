class Feedback < ActiveRecord::Base
  validates_presence_of :name, :email, :message

  belongs_to :user

  def self.default_scope
    where(deleted: false).order(created_at: :desc)
  end
end
