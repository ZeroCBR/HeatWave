require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should not get new" do
    get :new
    assert_response :failure
  end

  test "should show message" do
    get :show, id: @message
    assert_response :success
  end

  test "should not get edit" do
    get :edit, id: @message
    assert_response :success
  end
end
