class OrdersController < ApplicationController
  def update_cart
    cart = params[:cart].delete_if { |key, value| value == "0" }
    total = 0
    cart.each do |key, value|
      total += Product.find(key).price * value.to_i
    end
    session[:total] = total
    session[:cart] = cart

    render json: { status: 200, href: review_cart_path }
  end

  def empty_cart
    session[:cart] = nil
    session[:total] = nil

    redirect_to jerky_path
  end

  def review_cart
    redirect_to jerky_path unless session[:total] && session[:total] > 0

    @cart = session[:cart] || {}
    @total = session[:total]
  end

  def update_shipping
    params[:zipcode]

    render json: { status: 200, price: price }
  end

  def purchase
    # Not great logic?
    if current_user
      customer_token = Stripe.customer_token(charge_token: session[:charge_token])
      current_user.update_attributes(customer_token: customer_token)
      # Charge customer token
    else
      # Charge charge token
    end
    # Take shipping into account before charging

    @order = Order.create(
      charge_token: session[:charge_token],
      description: "Triple R Farms delicious Jerky infused with Cowboy Coffee.",
      user_id: current_user.try(:id),
      order_items: session[:order_items]
    )
    if @order.valid?
      session[:order_id] = order.id
    else
      redirect_to :back, alert: @order.errors.full_messages
    end
  rescue Stripe::Error => e
    redirect_to :back, alert: e.message
  end

  def index
    @orders = Order.all
  end

  private
  def order_params
    params.require(:order).permit(
      :charge_token,
      :first_name,
      :last_name,
      :phone_number,
      :address,
      :city,
      :state,
      :zipcode
    )
  end
end
