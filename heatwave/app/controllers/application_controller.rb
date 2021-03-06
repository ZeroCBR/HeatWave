##
# Main controller in charge of the entire application.
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected

  def configure_devise_permitted_parameters
    registration_params = [:id, :email, :password, :password_confirmation,
                           :f_name, :l_name, :gender, :phone, :age,
                           :message_type, :location_id]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) \
        { |u| u.permit(registration_params << :current_password) }

    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) \
        { |u| u.permit(registration_params) }
    end
  end

  def admin_user!
    return if current_user.admin_access

    flash[:alert] = 'Only administrators may view this page!'
    redirect_to root_path
  end

  def current_or_admin_user!
    return if current_user.admin_access
    return if current_user.id == @user.id

    flash[:alert] = "You don't have permission to view that page!"
    redirect_to root_path
  end
end
