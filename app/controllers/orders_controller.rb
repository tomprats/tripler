require 'active_shipping'
include ActiveMerchant::Shipping

class OrdersController < ApplicationController
  def update_cart
    if params[:cart]
      cart = params[:cart].delete_if { |key, value| value == "0" }
      total = 0
      cart.each do |key, value|
        total += Product.find(key).price * value.to_i
      end

      session[:cart] = cart
      session[:cart_total] = total
      session[:rates] = nil
      session[:shipping] = nil
      session[:shipping_total] = nil
      session[:shipping_zipcode] = nil
      session[:total] = nil

      render json: { status: 200, href: review_cart_path }
    else
      cart = session[:cart]
      cart[params[:product][:id]] = params[:product][:quantity]
      total = 0
      cart.each do |key, value|
        total += Product.find(key).price * value.to_i
      end
      product_total = Product.find(params[:product][:id]).price * params[:product][:quantity].to_i

      calculate_shipping if session[:shipping_zipcode]

      session[:cart] = cart
      session[:cart_total] = total
      session[:total] = session[:cart_total] + session[:shipping_total] if session[:shipping_total]

      render json: {
        total: session[:total] || session[:cart_total],
        shipping_total: session[:shipping_total],
        product_total: product_total
      }
    end
  end

  def empty_cart
    session[:cart] = nil
    session[:total] = nil
    session[:rates] = nil
    session[:shipping] = nil
    session[:shipping_total] = nil
    session[:shipping_zipcode] = nil

    redirect_to jerky_path
  end

  def review_cart
    redirect_to jerky_path unless session[:cart_total] && session[:cart_total] > 0

    @cart = session[:cart] || {}
    @total = session[:cart_total]
  end

  def update_shipping
    session[:shipping_zipcode] = params[:zipcode]

    calculate_shipping

    render json: { total: session[:total], shipping_total: session[:shipping_total] }
  end

  def purchase
    Stripe.api_key = ENV["STRIPE_SECRET"]
    card_token = params[:card_token]
    charge_token = nil
    charge_description = "Triple R Farms delicious Jerky infused with Cowboy Coffee."

    @order = Order.new(order_params.merge!(
      description: charge_description,
      shipping: session[:shipping],
      shipping_total: session[:shipping_total],
      total_price: session[:total],
      user_id: current_user.try(:id),
      order_items: order_items
    ))

    if @order.valid?
      if current_user
        customer_token = Stripe::Customer.create(
          card: card_token,
          description: "Customer for #{current_user.name} (id: #{current_user.id})"
        ).id
        current_user.update_attributes(customer_token: customer_token)
        charge_token = Stripe::Charge.create(
          amount: session[:total],
          currency: "usd",
          customer: customer_token,
          description: charge_description
        ).id
      else
        charge_token = Stripe::Charge.create(
          amount: session[:total],
          currency: "usd",
          card: card_token,
          description: charge_description
        ).id
      end
      @order.charge_token = charge_token
      @order.save!

      session[:order_id] = @order.id
    else
      redirect_to :back, alert: @order.errors.full_messages.join(", ")
    end
  rescue Stripe::StripeError => e
    puts e.message
    redirect_to :back, alert: e.message
  end

  def index
    @orders = Order.all
  end

  private
  def order_params
    params.require(:order).permit(
      :first_name,
      :last_name,
      :phone_number,
      :address,
      :city,
      :state,
      :zipcode
    )
  end

  def order_items
    session[:cart].collect do |key, value|
      product = Product.find(key)
      OrderItem.new(
        quantity: value,
        price: product.price,
        total_price: value.to_i * product.price,
        product_id: product.id,
        name: product.name,
        description: product.description,
        image: product.image.url
      )
    end
  end

  def calculate_shipping
    rates = Order.find_shipping(session[:items], session[:shipping_zipcode])
    session[:rates] = rates.rates.collect do |rate|
      {
        price: rate.total_price,
        name: rate.service_name,
      }
    end
    session[:shipping] = session[:rates].first[:name]
    session[:shipping_total] = session[:rates].first[:price]
    session[:total] = session[:shipping_total] + session[:cart_total]
  end
end
