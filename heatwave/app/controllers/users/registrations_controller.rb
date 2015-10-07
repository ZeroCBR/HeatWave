##
# Module for user related controllers.
module Users
  ##
  # Overriding controller for registration.
  # Overrides the default devise registrations controller.
  class RegistrationsController < Devise::RegistrationsController
    def new
      @locations = Location.all.sort_by(&:name)
      super
    end

    def create
      @user = User.new(user_params)

      if @user.save
        successful_user_save_response
      else
        clean_up_passwords @user
        @locations = Location.all.sort_by(&:name)
        render :new
      end
    end

    private

    def successful_user_save_response
      if @user.active_for_authentication?
        sign_up_active
      else
        sign_up_inactive
      end
    end

    def sign_up_active
      flash[:notice] = :signed_up if is_navigational_format?
      sign_up(:user, @user)
      respond_with @user, location: after_sign_up_path_for(@user)
    end

    def sign_up_inactive
      if is_navigational_format?
        flash[:notice] = "signed_up_but_#{@user.inactive_message}"
      end
      expire_session_data_after_sign_in!
      respond_with @user, location: after_inactive_sign_up_path_for(@user)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :f_name, :l_name, :gender, :phone, :age,
                                   :message_type, :location_id)
    end
  end
end
