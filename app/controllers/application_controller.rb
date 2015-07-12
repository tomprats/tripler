class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :verify_admin

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def current_order
    # @current_order ||= Order.find_by(id: session[:order_id])

    @current_order || Order.from_session(session[:order])
  end
  helper_method :current_order

  def log_in(user)
    session[:user_id] = user.id if user.try(:id)
  end
  helper_method :log_in

  def log_out
    session[:user_id] = nil
  end
  helper_method :log_out

  def verify_admin
    if request.subdomain.downcase == "admin"
      if params[:token]
        user = User.find_by(password_digest: params[:token])
        if user
          session[:user_id] = user.id
          redirect_to root_path
        else
          redirect_to root_url(subdomain: "")
        end
      else
        redirect_to root_url(subdomain: "") unless current_user && current_user.admin?
      end
    end
  end
end
