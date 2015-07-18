class User < ActiveRecord::Base
  has_many :orders
  has_many :feedback
  has_secure_password
  validates_uniqueness_of :email

  def self.admins
    where(admin: true)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin
  end

  def default_scope
    order(last_name: :desc, first_name: :desc)
  end

  def create_customer_token(card_token)
    Stripe.api_key = ENV["STRIPE_SECRET"]
    customer_token = Stripe::Customer.create(
      card: card_token,
      email: email,
      description: "Customer for #{name} (id: #{id})"
    ).id
    update(customer_token: customer_token)

    customer_token
  end
end
