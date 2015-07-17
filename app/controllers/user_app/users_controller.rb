module UserApp
  class UsersController < UserApplicationController
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

    private
    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :additional_emails,
        :phone_number,
        :address1,
        :address2,
        :city,
        :state,
        :zipcode,
        :password,
        :password_confirmation
      )
    end
  end
end
