class UsersController < ApplicationController
  def admin
    if current_user.admin?
      redirect_to root_url(token: current_user.password_digest, subdomain: :admin)
    else
      redirect_to :back
    end
  end

  def registration
    user = User.create(user_params)
    if user.valid?
      log_in(user)
      render json: { status: 200 }
    else
      render json: { status: 400, message: user.errors.full_messages }
    end
  end

  def sign_in
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      log_in(user)
      render json: { status: 200 }
    else
      render json: { status: 400, message: ["Invalid email/password"] }
    end
  end

  def sign_out
    log_out
    redirect_to root_path
  end

  def index
    @users = User.all
  end

  def toggle_admin
    unless params[:id] == "1"
      user = User.find_by(id: params[:id])
      user && user.update_attributes(admin: !user.admin)
    end
    redirect_to :back
  end

  private
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone_number,
      :address,
      :city,
      :state,
      :zipcode,
      :password,
      :password_confirmation
    )
  end
end
