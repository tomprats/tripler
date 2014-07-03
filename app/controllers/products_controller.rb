class ProductsController < ApplicationController
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
  end

  def delete
  end

  private
  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :image
    )
  end
end
