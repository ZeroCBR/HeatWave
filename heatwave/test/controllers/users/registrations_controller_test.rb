require 'test_helper'

##
# Module for users related tests.
module Users
  ##
  # Functional tests for valid uses of the registrations controller.
  class ValidRegistrationsControllerTest < ActionController::TestCase
    setup do
      user = User.find_by(email: USER1[:email])
      user.delete if user
      user = User.find_by(email: USER2[:email])
      user.delete if user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @controller = Users::RegistrationsController.new
    end

    test 'registrations#new should provide a form for a new user' do
      get :new
      assert_response :success

      assert_not_nil assigns(:user)
      assert_empty assigns(:user).email
      assert_nil assigns(:user).password
      assert_nil assigns(:user).password_confirmation
      assert_empty assigns(:user).encrypted_password
      assert_nil assigns(:user).f_name
      assert_nil assigns(:user).l_name
      assert_nil assigns(:user).gender
      assert_not assigns(:user).admin_access
      assert_nil assigns(:user).location
      assert_nil assigns(:user).message_type
      assert_nil assigns(:user).phone
    end

    test 'registrations#create should allow a good user' do
      user = USER1.clone
      assert_difference('User.count', 1) { post :create, user: user }
      assert_response :redirect
    end

    test 'registrations#create should allow another good user' do
      user = USER2.clone
      assert_difference('User.count', 1) { post :create, user: user }
      assert_response :redirect
    end

    test 'registrations#create should allow nil admin access' do
      user = USER1.clone
      user[:admin_access] = nil

      assert_difference('User.count', 1) { post :create, user: user }
      assert_response :redirect
    end
  end

  ##
  # Functional tests for invalid uses of the registrations controller.
  class InvalidRegistrationsControllerTest < ActionController::TestCase
    setup do
      user = User.find_by(email: USER1[:email])
      user.delete if user
      user = User.find_by(email: USER2[:email])
      user.delete if user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @controller = Users::RegistrationsController.new
    end

    test 'registrations#create should prevent mismatched passwords' do
      user = USER2.clone
      user[:password] = 'password'
      user[:password_confirmation] = 'different'

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent too short passwords' do
      user = USER1.clone
      user[:password] = 'short'
      user[:password_confirmation] = 'short'

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent missing first names' do
      user = USER1.clone
      user[:f_name] = nil

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent blank first names' do
      user = USER1.clone
      user[:f_name] = ''

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent missing last names' do
      user = USER1.clone
      user[:l_name] = nil

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent blank last names' do
      user = USER1.clone
      user[:l_name] = ''

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent missing gender' do
      user = USER2.clone
      user[:gender] = nil

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent blank gender' do
      user = USER2.clone
      user[:gender] = ''

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent tiny ages' do
      user = USER2.clone
      user[:age] = 17

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent missing emails' do
      user = USER1.clone
      user[:email] = nil

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent blank emails' do
      user = USER1.clone
      user[:email] = ''

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent duplicate emails' do
      user = USER1.clone
      user[:email] = users(:one).email

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
      assert_equal User.find_by(email: user[:email]).f_name, users(:one).f_name
    end

    test 'registrations#create should prevent bad message_types' do
      user = USER1.clone
      user[:message_type] = 'a bad message type'

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end

    test 'registrations#create should prevent bad locations' do
      user = USER1.clone
      user[:location_id] = 34

      assert_difference('User.count', 0) { post :create, user: user }
      assert_response :success
    end
  end

  USER1 = { f_name: 'Good',
            l_name: 'User',
            password: 'A password',
            password_confirmation: 'A password',
            admin_access: true,
            gender: 'M',
            age: 18,
            email: 'first@email.com',
            message_type: 'email',
            location_id: 2 }

  USER2 = { f_name: 'Other',
            l_name: 'User',
            password: 'Other password',
            password_confirmation: 'Other password',
            admin_access: false,
            gender: 'F',
            age: 42,
            email: 'another@email.com',
            message_type: 'phone',
            location_id: 1 }
end
