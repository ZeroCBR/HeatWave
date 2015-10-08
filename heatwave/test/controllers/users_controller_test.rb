require 'test_helper'

## Tests for the users controller as a normal user.
class NormalUsersControllerTest < ActionController::TestCase
  setup do
    sign_in(users(:one))
    @user = users(:one)
    @controller = UsersController.new
  end

  test 'users#index should be blocked for normal users' do
    get :index
    assert_response :redirect
  end

  test 'users#show should show for the current user' do
    get :show, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_equal @user.email, assigns(:user).email
    assert_equal @user.f_name, assigns(:user).f_name
    assert_equal @user.l_name, assigns(:user).l_name
    assert_equal @user.admin_access, assigns(:user).admin_access
    assert_equal @user.gender, assigns(:user).gender
    assert_equal @user.phone, assigns(:user).phone
    assert_equal @user.age, assigns(:user).age
    assert_equal @user.message_type, assigns(:user).message_type
    assert_equal @user.location, assigns(:user).location
  end

  test 'users#show should not show a different user for a normal user' do
    get :show, id: users(:two).id
    assert_response :redirect
  end
end

## Tests for the users controller as an admin.
class AdminUsersControllerTest < ActionController::TestCase
  setup do
    sign_in(users(:two))
    @user = users(:two)
    @controller = UsersController.new
  end

  test 'users#index should show all users for admins' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
    assert_equal User.count, assigns(:users).length
  end

  test 'users#show should show for the current user' do
    get :show, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_equal @user.email, assigns(:user).email
    assert_equal @user.f_name, assigns(:user).f_name
    assert_equal @user.l_name, assigns(:user).l_name
    assert_equal @user.admin_access, assigns(:user).admin_access
    assert_equal @user.gender, assigns(:user).gender
    assert_equal @user.phone, assigns(:user).phone
    assert_equal @user.age, assigns(:user).age
    assert_equal @user.message_type, assigns(:user).message_type
    assert_equal @user.location, assigns(:user).location
  end

  test 'users#show should show a any user for an admin user' do
    @user = users(:one)
    get :show, id: @user.id
    assert_response :success
    assert_not_nil assigns(:user)
    assert_equal @user.email, assigns(:user).email
    assert_equal @user.f_name, assigns(:user).f_name
    assert_equal @user.l_name, assigns(:user).l_name
    assert_equal @user.admin_access, assigns(:user).admin_access
    assert_equal @user.gender, assigns(:user).gender
    assert_equal @user.phone, assigns(:user).phone
    assert_equal @user.age, assigns(:user).age
    assert_equal @user.message_type, assigns(:user).message_type
    assert_equal @user.location, assigns(:user).location
  end
end
