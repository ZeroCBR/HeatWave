# Control the user page
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :admin_user!, except: [:profile, :show]
  before_action :current_or_admin_user!, only: [:show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @locations = Location.all.sort_by(&:name)
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @locations = Location.all.sort_by(&:name)
    respond_to do |format|
      html_respond_to(format, 'create', 'created', :new) { @user.save }
    end
  end

  # GET /users/1/edit
  def edit
    @locations = Location.all.sort_by(&:name)
  end

  # PATCH /users/1
  def update
    @locations = Location.all.sort_by(&:name)
    user = user_params
    user.delete :password if user[:password] == ''
    respond_to do |format|
      html_respond_to(format, 'update', 'updated', :edit) \
        { @user.update(user) }
    end
  end

  # GET /
  def profile
    @user = current_user
    render :show
  end

  private

  def successful_update_response
    flash[:notice] = :updated if is_flashing_format?
    sign_in :user, @user, bypass: true
    respond_with @user, location: after_update_path_for(resource)
  end

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the
  # white list through.
  def user_params
    params.require(:user).permit(:email, :password, :f_name, :l_name,
                                 :gender, :phone, :age, :admin_access,
                                 :message_type, :location_id)
  end

  def html_respond_to(format, present_tense, past_tense, alternative)
    if yield
      format.html do
        redirect_to @user, notice: "Successfully #{past_tense} the user"
      end
    else
      format.html do
        flash.now[:alert] = "Failed to #{present_tense} the user"
        render alternative
      end
    end
  end
end
