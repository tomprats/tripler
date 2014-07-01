class User < ActiveRecord::Base
  has_many :orders
  has_many :feedback

  def name
    "#{first_name} #{last_name}"
  end
end
