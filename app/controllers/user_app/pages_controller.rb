module UserApp
  class PagesController < UserApplicationController
    def jerky
      @products = Product.where(coming_soon: false)
      @coming_soon = Product.where(coming_soon: true)
      @order = current_order
    end
  end
end
