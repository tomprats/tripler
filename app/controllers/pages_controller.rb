class PagesController < ApplicationController
  def jerky
    @products = Product.where(coming_soon: false)
    @coming_soon = Product.where(coming_soon: true)
    @cart = session[:cart] || {}
    @total = session[:cart_total] || 0
    @packs, @packless = packs
  end

  private
  def packs
    quantity = (session[:cart] || {}).sum{ |i| i.last.to_i }
    [quantity / 8, quantity % 8]
  end
end
