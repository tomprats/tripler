module AdminApp
  class OrdersController < AdminApplicationController
    def index
      @orders = Order.all
    end

    def show
      @order = Order.find(params[:id])
    end

    def toggle_shipped
      order = Order.find_by(id: params[:id])
      order && order.update_attributes(
        shipped: !order.shipped,
        shipped_date: DateTime.now,
        shipped_admin_id: current_user.id
      )
      redirect_to :back
    end
  end
end
