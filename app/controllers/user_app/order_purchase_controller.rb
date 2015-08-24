module UserApp
  class OrderPurchaseController < UserApplicationController
    def new
      @order = current_order
      @rate = session[:rate]
    end

    def create
      @order = current_order
      @order.checkout(params[:card_token], current_user.try(:id))

      AdminEmailer.order_email(@order).deliver

      purge_order
      redirect_to order_purchased_path
    rescue => e
      logger.error e.message

      redirect_to :back, alert: "There was an error, please try again and/or contact us at 717-542-4022"
    end
  end
end
