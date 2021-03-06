module AdminApp
  class ProductsController < AdminApplicationController
    def create
      product = Product.create(product_params)
      if product.valid?
        render json: { status: 200 }
      else
        render json: { status: 400, message: product.errors.full_messages }
      end
    end

    def index
      @products = Product.all
    end

    def update
      product = Product.find_by(id: params[:id])
      if product && product.update_attributes(product_params)
        render json: { status: 200 }
      elsif product.nil?
        render json: { status: 500, message: ["Product could not be updated"] }
      else
        render json: { status: 400, message: product.errors.full_messages }
      end
    end

    def destroy
      Product.find_by(id: params[:id]).try(:destroy)
      redirect_to :back
    end

    private
    def product_params
      params[:product][:price] = (params[:product][:price].to_f * 100).to_i if params[:product][:price]
      params.require(:product).permit(
        :name,
        :description,
        :price,
        :position,
        :coming_soon,
        :image
      )
    end
  end
end
