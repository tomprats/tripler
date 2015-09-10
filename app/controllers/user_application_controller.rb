class UserApplicationController < ApplicationController

  def purge_order
    session[:order] = session[:shipping] = session[:rates] = session[:rate] = nil
  end
  helper_method :purge_order

  def current_order
    @current_order ||= Order.from_session(session[:order])
  end
  helper_method :current_order

  def reset_shipping
    session[:rates] = session[:rate] = nil
    session[:order] ||= {}
    session[:order].merge!({ shipping: nil, shipping_total: nil }.deep_stringify_keys)
  end
end
