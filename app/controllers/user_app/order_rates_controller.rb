module UserApp
  class OrderRatesController < UserApplicationController
    def index
      @rates = current_order.find_rates
      @rates = @rates.rates.collect do |r|
        {
          rate: r.service_code,
          service: r.service_name,
          price: r.total_price,
          date: r.delivery_date
        }
      end.delete_if { |r| !Order.accepted_services.include? r[:rate] }

      session[:rates] = @rates
    end

    def create
      rate = session[:rates].find { |r| r[:rate] == params[:rate] }

      session[:rate] = rate
      update_order(
        shipping: rate[:service],
        shipping_total: rate[:price] * current_order.packs
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
