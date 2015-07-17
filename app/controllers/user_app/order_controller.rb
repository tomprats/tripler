module UserApp
  class OrderController < UserApplicationController
    def create
      session[:order] = nil
      hash = remove_empty_items order_params
      update_order hash

      if current_order.valid_packs?
        render json: { status: 200, href: order_path }
      else
        flash[:alert] = "Order must fit into packs of 8"
        render json: { status: 200, href: jerky_path }
      end
    end

    def edit
      @order = current_order

      redirect_to jerky_path unless @order.total_price > 0
    end

    def show
      @order = current_order
    end

    def update
      update_product params[:product]

      render json: current_order.to_json(
        include: :order_items,
        methods: [:subtotal, :packs, :packless]
      )
    end

    def destroy
      purge_order

      redirect_to jerky_path
    end

    def purchase
      if packs[1].zero?
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

          AdminEmailer.order_email(@order).deliver

          session[:orders] ||= []
          session[:orders].push(@order.id)
          session[:cart] = nil
          session[:cart_total] = nil
          session[:rates] = nil
          session[:shipping] = nil
          session[:shipping_total] = nil
          session[:shipping_zipcode] = nil
          session[:total] = nil

          redirect_to purchased_path
        else
          redirect_to :back, alert: @order.errors.full_messages.join(", ")
        end
      else
        redirect_to :back, alert: "Order must fit into packs of 8"
      end
    end

    private
    def order_params
      params.require(:order).permit(
        :first_name, :last_name, :email,
        :phone_number, :address1, :address2,
        :city, :state, :zipcode,
        order_items_attributes: [
          :product_id, :quantity
        ]
      )
    end

    def remove_empty_items(hash)
      return hash unless hash[:order_items_attributes]
      items = hash[:order_items_attributes]
      hash[:order_items_attributes] = items.collect { |k,v| v unless v[:quantity].to_i.zero? }.compact
      hash
    end

    def update_order(hash)
      session[:order] ||= {}
      session[:order].merge!(hash.deep_stringify_keys)
    end

    def update_product(hash)
      hash.deep_stringify_keys!
      session[:order] ||= {}
      session[:order]["order_items_attributes"] ||= []
      index = session[:order]["order_items_attributes"].index do |order_item|
        order_item["product_id"] == hash[:product_id]
      end
      session[:order]["order_items_attributes"][index] = hash if index
    end
  end
end
