module UserApp
  class OrderController < UserApplicationController
    before_action :reset_shipping

    def create
      session[:order] = nil
      hash = remove_empty_items order_params
      update_order hash

      render json: { status: 200, href: order_path }
    end

    def edit
      @products = Product.where(coming_soon: false)
      @order = current_order
    end

    def show
      @order = current_order
    end

    def update
      update_product params[:product]

      render json: current_order.to_json(
        include: :order_items,
        methods: [:subtotal]
      )
    end

    def destroy
      purge_order

      redirect_to jerky_path
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
      if index
        session[:order]["order_items_attributes"][index] = hash
      else
        session[:order]["order_items_attributes"].push hash
      end
    end
  end
end
