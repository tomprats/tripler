module UserApp
  class PagesController < UserApplicationController
    before_action :reset_shipping

    def home
      @original = Product.normal.original.first
      @coffee = Product.coffee.original.first
      @order = current_order
    end

    def jerky
      @products = Product.where(coming_soon: false)
      @coming_soon = Product.where(coming_soon: true)
      @order = current_order
    end
  end
end
