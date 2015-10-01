module UserApp
  class OrderRatesController < UserApplicationController
    def index
      @order = current_order
      @rates = @order.find_rates

      session[:rates] = @rates
    end

    def create
      rate = session[:rates].find { |service, r| service == params[:rate] }[1]

      session[:rate] = rate
      update_order(
        shipping: rate[:service],
        shipping_total: rate[:price]
      )

      redirect_to order_purchase_path
    end

    private
    def update_order(hash)
      session[:order] ||= {}
      session[:order].merge!(hash.deep_stringify_keys)
    end
  end
end
