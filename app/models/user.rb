class User < ActiveRecord::Base
  has_many :orders
  has_many :feedback
  has_secure_password
  validates_uniqueness_of :email

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin
  end

  def default_scope
    order(last_name: :desc, first_name: :desc)
  end
end
