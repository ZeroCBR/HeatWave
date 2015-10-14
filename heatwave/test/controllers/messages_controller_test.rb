require 'test_helper'
# basic test set for the Messages controller
class NormalUserMessagesControllerTest < ActionController::TestCase
  setup do
    sign_in(users(:one))
    @user = users(:one)
    @message_1 = messages(:one)
    @message_1.user_id = @user.id
    @message_2 = messages(:two)
    @message_2.user_id = users(:two).id
    @message_1.save
    @message_2.save
    @controller = MessagesController.new
  end

  test 'messages#index should only show personal messages for normal users' do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
    assert_equal 1, assigns(:messages).size
    assert_equal @message_1, assigns(:messages).pop
  end

  test 'messages#show should work for a user\'s own messages' do
    get :show, id: @message_1.id
    assert_response :success
    assert_not_nil assigns(:message)
    assert_equal @message_1.id, assigns(:message).id
    assert_equal @message_1.contents, assigns(:message).contents
    assert_equal @message_1.rule_id, assigns(:message).rule_id
    assert_equal @message_1.weather_id, assigns(:message).weather_id
    assert_equal @message_1.sent_to, assigns(:message).sent_to
    assert_equal @message_1.message_type, assigns(:message).message_type
  end

  test 'messages#show should not work for another user\'s messages' do
    get :show, id: @message_2.id
    assert_response :redirect
  end

  test 'message#edit should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { get :edit, id: @message_1.id }
    assert_raises(ActionController::UrlGenerationError) \
      { get :edit, id: @message_2.id }
  end

  test 'message#new should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { get :new}
  end

  test 'message#create should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { post :create}
  end

  test 'message#update should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { put :update}
  end

  test 'message#destroy should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { delete :destroy}
  end

end
# cases where the Admin is logged in
class AdminMessagesControllerTest < ActionController::TestCase
  setup do
    sign_in(users(:two))
    @user = users(:two)
    @normal_user = users(:one)
    @message_1 = messages(:one)
    @message_1.user_id = @normal_user.id
    @message_2 = messages(:two)
    @message_2.user_id = @user.id
    @message_1.save
    @message_2.save
    @controller = MessagesController.new
  end

  test 'messages#index should show all messages for admins' do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
    assert_equal Message.count, assigns(:messages).size
  end

  test 'messages#show should always work when you\'re an admin' do
    get :show, id: @message_2.id
    assert_response :success
    assert_not_nil assigns(:message)
    assert_equal @message_2.id, assigns(:message).id
    assert_equal @message_2.contents, assigns(:message).contents
    assert_equal @message_2.rule_id, assigns(:message).rule_id
    assert_equal @message_2.weather_id, assigns(:message).weather_id
    assert_equal @message_2.sent_to, assigns(:message).sent_to
    assert_equal @message_2.message_type, assigns(:message).message_type
  end

  test 'messages#show should even work for another user\'s messages' do
    get :show, id: @message_1.id
    assert_response :success
    assert_not_nil assigns(:message)
    assert_equal @message_1.id, assigns(:message).id
    assert_equal @message_1.contents, assigns(:message).contents
    assert_equal @message_1.rule_id, assigns(:message).rule_id
    assert_equal @message_1.weather_id, assigns(:message).weather_id
    assert_equal @message_1.sent_to, assigns(:message).sent_to
    assert_equal @message_1.message_type, assigns(:message).message_type
  end

  test 'message#edit should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { get :edit, id: @message_1.id }
    assert_raises(ActionController::UrlGenerationError) \
      { get :edit, id: @message_2.id }
  end

  test 'message#new should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { get :new}
  end

  test 'message#create should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { post :create}
  end

  test 'message#update should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { put :update}
  end

  test 'message#destroy should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { delete :destroy}
  end

end
