class PagesController < ApplicationController
  def home
  end

  def about
  end

  def jerky
    @products = Product.all
    @cart = session[:cart] || {}
    @total = session[:cart_total] || 0
  end

  def locations
  end

  def contact
  end
end
