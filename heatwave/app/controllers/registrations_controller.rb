##
# Overriding controller for registration.
# Overrides the default devise registrations controller.
class RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    render profile_path if user_signed_in?
    @locations = Location.all.sort_by(&:name)
    super
  end

  def create
    @user = User.new(user_params)

    if @user.save
      successful_create_response
    else
      clean_up_passwords @user
      @locations = Location.all.sort_by(&:name)
      render :new
    end
  end

  def edit
    @locations = Location.all.sort_by(&:name)
    super
  end

  def update
    @locations = Location.all.sort_by(&:name)
    super
  end

  def destroy
    @user.unsubscribe
    Devise.sign_out_all_scopes ? sign_out : sign_out(@user)
    if is_flashing_format?
      set_flash_message :notice,
                        'You have succesfully unsubscribed'
    end
    redirect_to after_sign_out_path_for(User)
  end

  private

  def set_user
    @user = current_user
  end

  def successful_create_response
    if @user.active_for_authentication?
      flash[:notice] = 'Successfully signed up' if is_navigational_format?
      sign_up :user, @user
      respond_with @user, location: after_sign_up_path_for(@user)
    else
      flash_key = "signed_up_but_#{@user.inactive_message}"
      flash[:notice] = flash_key if is_navigational_format?
      expire_data_after_sign_in!
      respond_with @user, location: after_inactive_sign_up_path_for(@user)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :f_name, :l_name, :gender, :phone, :age,
                                 :message_type, :location_id, :current_password)
  end
end
