module UserApp
  class OrderPurchaseController < UserApplicationController
    def new
      # Check to ensure complete order
      @order = current_order
      @rate = session[:rate]
    end

    def create
      @order = current_order
      @order.checkout(params[:card_token], current_user.try(:id))

      AdminEmailer.order_email(@order).deliver

      purge_order
      redirect_to order_purchased_path
    rescue Stripe::StripeError => e
      logger.error e.message

      redirect_to :back, alert: e.message
    end
  end
end
