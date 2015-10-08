# Control the user page
class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :admin_user!, only: [:index]
  before_action :current_or_admin_user!, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /
  def profile
    @user = current_user
    render :show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the
  # white list through.
  def user_params
    params.require(:user).permit(:username, :f_name,
                                 :l_name, :password, :admin_access, :gender,
                                 :address, :phone, :age, :email, :suscribed,
                                 :birthday, :postcode)
  end
end
