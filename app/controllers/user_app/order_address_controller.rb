module UserApp
  class OrderAddressController < UserApplicationController
    def new
      if !current_order.valid_packs?
        flash[:alert] = "Order must fit into packs of #{Order.size}"
        redirect_to :back
      end
    end

    def create
      session[:shipping] = {}
      session[:rates] = session[:rate] = nil
      update_order order_params

      if current_order.package_params?
        result = current_order.validate_address
        update_shipping(
          address: result.address.try(:to_hash),
          cleanse_hash: result.override_hash,
          override_hash: result.override_hash
        )

        @address = result.address.try(:prettyprint)
        @match = result.address_match
        error = !result.city_state_zip_ok
      else
        error = true
      end

      if error
        render json: { status: 400, message: "Invalid shipping details. Please ensure you fill out all required fields." }
      else
        render json: { status: 200, location: order_address_edit_path }
      end
    end

    def edit
      if current_order.package_params?
        result = current_order.validate_address
        update_shipping(
          address: result.address.try(:to_hash),
          cleanse_hash: result.override_hash,
          override_hash: result.override_hash
        )

        @address = result.address.try(:prettyprint)
        @match = result.address_match
        error = !result.city_state_zip_ok
      else
        error = true
      end

      if error
        redirect_to order_address_path, alert: "Invalid shipping details. Please ensure you fill out all required fields."
      end
    end

    def update
      session[:rates] = session[:rate] = nil

      if params[:override]
        update_order(
          city: address.city,
          state: address.state,
          zipcode: address.zip
        )
      else
        update_order(
          address1: address.address1,
          address2: address.address2,
          city: address.city,
          state: address.state,
          zipcode: address.zip
        )
      end

      redirect_to order_rates_path
    end

    private
    def order_params
      params.require(:order).permit(
        :first_name, :last_name, :email,
        :phone_number, :address1, :address2,
        :city, :state, :zipcode
      )
    end

    def update_order(hash)
      session[:order] ||= {}
      session[:order].merge!(hash.deep_stringify_keys)
    end

    def address
      ActiveShipping::Location.new(session[:shipping].deep_symbolize_keys[:address])
    end

    def update_shipping(hash)
      session[:shipping] ||= {}
      session[:shipping].merge!(hash.deep_stringify_keys)
    end
  end
end
