class PagesController < ApplicationController
  def home
  end

  def about
  end

  def jerky
    @products = Product.all
  end

  def locations
  end

  def contact
  end
end
