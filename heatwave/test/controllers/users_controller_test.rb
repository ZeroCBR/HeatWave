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

  test 'users#new should not work for a normal user' do
    get :new
    assert_response :redirect
  end

  test 'users#edit should not work for a normal user' do
    get :edit, id: @user.id
    assert_response :redirect
  end

  test 'users#create should not work for a normal user' do
    assert_difference('User.count', 0) do
      post :create, user: { email: @user.email + 'a',
                            password: @user.password,
                            f_name: @user.f_name,
                            l_name: @user.l_name,
                            location_id: @user.location_id,
                            message_type: @user.message_type,
                            admin_access: @user.admin_access }
    end

    assert_response :redirect
  end

  test 'users#update should not work for a normal user' do
    put :update, id: @user.id, user: { f_name: @user.f_name + 'asdad' }

    assert_response :redirect

    result = User.find(@user.id)
    assert_equal result.f_name, @user.f_name
  end
end

##
# Functional tests for invalid email and/or password updates for
# the users controller.
class BadLoginUpdateUsersControllerTest < ActionController::TestCase
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:one)
    sign_in(users(:two))
    @controller = UsersController.new
  end

  test 'users#update should prevent mismatched passwords' do
    user = USER1
    user[:password] = 'password'
    user[:password_confirmation] = 'different'

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent too short passwords' do
    user = USER1
    user[:password] = 'short'
    user[:password_confirmation] = 'short'

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent missing emails' do
    user = USER1
    user[:email] = nil

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent blank emails' do
    user = USER1
    user[:email] = ''

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent duplicate emails' do
    user = USER1
    user[:email] = users(:two).email

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  def assert_equal_personal_details(a, b)
    assert_equal a.f_name, b.f_name
    assert_equal a.l_name, b.l_name
    assert_equal a.gender, b.gender
  end

  def assert_equal_statistics(a, b)
    assert_equal a.location_id, b.location_id
    assert_equal a.message_type, b.message_type
    assert_equal a.phone, b.phone
  end

  def assert_no_change(user)
    assert_difference('User.count', 0) \
      { patch :update, user: user, id: @user.id }
    assert_response :success
  end
end

##
# Functional tests for valid updates with the users controller.
class UpdateUsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:two)
    sign_in(users(:two))
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @controller = UsersController.new
  end

  test 'users#edit should provide a form for the user' do
    get :edit, id: @user.id
    assert_response :success

    assert_not_nil assigns(:user)
    assert_equal assigns(:user).email, @user.email
    assert_equal assigns(:user).password, nil
    assert_equal assigns(:user).password_confirmation, nil
    assert_equal assigns(:user).f_name, @user.f_name
    assert_equal assigns(:user).l_name, @user.l_name
    assert_equal assigns(:user).gender, @user.gender
    assert_equal assigns(:user).location, @user.location
    assert_equal assigns(:user).message_type, @user.message_type
    assert_equal assigns(:user).phone, @user.phone
  end

  test 'users#update should allow a good changeset' do
    @user = users(:two)
    assert_difference('User.count', 0) do
      patch :update, id: @user.id,
                     user: { email: @user.email + '3',
                             password: '12345678',
                             f_name: @user.f_name,
                             l_name: @user.l_name,
                             gender: @user.gender,
                             age: @user.age,
                             location_id: @user.location_id,
                             message_type: @user.message_type,
                             phone: @user.phone }
    end
    assert_response :redirect
    user = User.find_by(id: users(:two).id)
    assert_equal @user.f_name, user.f_name
    assert_equal @user.l_name, user.l_name
    assert_equal @user.gender, user.gender
    assert_equal @user.location_id, user.location_id
    assert_equal @user.message_type, user.message_type
    assert_equal @user.phone, user.phone
    User.find_by(email: @user.email + '3').delete
  end

  test 'users#update should allow another good changeset' do
    @user = users(:one)
    assert_difference('User.count', 0) do
      patch :update, id: @user.id,
                     user: { email: @user.email + '4',
                             password: '12345678',
                             f_name: @user.f_name + 'a',
                             l_name: @user.l_name,
                             gender: 'asdasdasd',
                             age: @user.age,
                             location_id: @user.location_id,
                             message_type: @user.message_type,
                             phone: @user.phone }
    end
    assert_response :redirect
    user = User.find_by(id: users(:one).id)
    assert_equal @user.f_name + 'a', user.f_name
    assert_equal @user.l_name, user.l_name
    assert_equal 'asdasdasd', user.gender
    assert_equal @user.location_id, user.location_id
    assert_equal @user.message_type, user.message_type
    assert_equal @user.phone, user.phone
    User.find_by(email: @user.email + '4').delete
  end
end

##
# Functional tests for invalid personal details and stat updates for
# the users controller.
class BadDetailsUpdateUsersControllerTest < ActionController::TestCase
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:one)
    sign_in(users(:two))
    @controller = UsersController.new
  end

  test 'users#update should prevent missing first names' do
    user = USER1
    user[:f_name] = nil

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent blank first names' do
    user = USER1
    user[:f_name] = ''

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent missing last names' do
    user = USER1
    user[:l_name] = nil

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent blank last names' do
    user = USER1
    user[:l_name] = ''

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent missing gender' do
    user = USER2
    user[:gender] = nil

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent blank gender' do
    user = USER2
    user[:gender] = ''

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent bad message_types' do
    user = USER1
    user[:message_type] = 'a bad message type'

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent bad locations' do
    user = USER1
    user[:location_id] = 34

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  test 'users#update should prevent tiny ages' do
    user = USER2
    user[:age] = 17

    assert_no_change(user)
    assert_equal_personal_details @user, User.find_by(id: @user.id)
    assert_equal_statistics @user, User.find_by(id: @user.id)
  end

  def assert_equal_personal_details(a, b)
    assert_equal a.f_name, b.f_name
    assert_equal a.l_name, b.l_name
    assert_equal a.gender, b.gender
  end

  def assert_equal_statistics(a, b)
    assert_equal a.location_id, b.location_id
    assert_equal a.message_type, b.message_type
    assert_equal a.phone, b.phone
  end

  def assert_no_change(user)
    assert_difference('User.count', 0) \
      { patch :update, user: user, id: @user.id }
    assert_response :success
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
