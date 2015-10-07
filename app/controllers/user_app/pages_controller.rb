module UserApp
  class PagesController < UserApplicationController
    before_action :reset_shipping

    def home
      @original = Product.normal.original.first
      @coffee = Product.coffee.original.first
      @order = current_order
    end

    def jerky
      @products = Product.available
      @coming_soon = Product.normal.coming_soon
      @order = current_order
    end
  end
end
