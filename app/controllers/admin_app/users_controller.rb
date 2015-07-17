module AdminApp
  class UsersController < AdminApplicationController
    def index
      @users = User.all
    end

    def update
      user = current_user
      if user && user.update_attributes(user_params)
        render json: { status: 200 }
      elsif user.nil?
        render json: { status: 500, message: ["User could not be updated"] }
      else
        render json: { status: 400, message: user.errors.full_messages }
      end
    end

    def toggle_admin
      unless params[:id] == "1"
        user = User.find_by(id: params[:id])
        user && user.update_attributes(admin: !user.admin)
      end
      redirect_to :back
    end

    def return
      session[:user_id] = nil
      redirect_to root_url(subdomain: nil)
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
