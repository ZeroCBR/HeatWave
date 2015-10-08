require 'test_helper'

# Test the feedback controller with a normal user.
class NormalFeedbacksControllerTest < ActionController::TestCase
  setup do
    @feedback = feedbacks(:one)
    @controller = FeedbacksController.new
    sign_in(users(:one))
  end

  test 'feedback#index should prevent access for normal users' do
    get :index
    assert_response :redirect
    assert_nil assigns(:feedbacks)
  end

  test 'feedback#new should provide an empty feedback for normal users' do
    get :new
    assert_response :success

    assert_not_nil assigns(:feedback)
    assert_nil assigns(:feedback).title
    assert_nil assigns(:feedback).content
    assert_nil assigns(:feedback).comment
    assert_nil assigns(:feedback).responded
  end

  test 'feedback#create should create feedback and redirect for normal users' do
    assert_difference('Feedback.count', 1) do
      post :create, feedback: { title: @feedback.title,
                                content: @feedback.content,
                                comment: @feedback.comment,
                                responded: @feedback.responded }
    end
    assert_response :redirect

    assert_redirected_to feedback_path(assigns(:feedback))
  end

  test 'feedback#show should prevent access for normal users' do
    get :show, id: @feedback.id
    assert_response :redirect
  end

  test 'feedback#edit should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { get :edit, id: @feedback.id }
  end

  test 'feedback#update should have no route' do
    assert_raises(ActionController::UrlGenerationError) do
      patch :update, id: @feedback.id,
                     feedback: { title: @feedback.title,
                                 content: @feedback.content,
                                 comment: @feedback.comment,
                                 responded: @feedback.responded }
    end
  end

  test 'feedback#destroy should prevent access for normal users' do
    Feedback.find(@feedback.id).update(responded: false)
    assert_difference('Feedback.count', 0) do
      delete :destroy, id: @feedback.id
    end
    assert_equal false, Feedback.find(@feedback.id).responded

    assert_response :redirect
  end
end

# Test the feedbacks controller with an admin user.
class AdminFeedbacksControllerTest < ActionController::TestCase
  setup do
    @feedback = feedbacks(:one)
    @controller = FeedbacksController.new
    sign_in(users(:two))
  end

  test 'feedback#index should succeed providing feedbacks for admins' do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedbacks)
    assert_equal Feedback.count, assigns(:feedbacks).length
  end

  test 'feedback#new should succeed providing an empty feedback for admins' do
    get :new
    assert_response :success

    assert_not_nil assigns(:feedback)
    assert_nil assigns(:feedback).title
    assert_nil assigns(:feedback).content
    assert_nil assigns(:feedback).comment
    assert_nil assigns(:feedback).responded
  end

  test 'feedback#create should create a feedback and redirect for admins' do
    assert_difference('Feedback.count', 1) do
      post :create, feedback: { title: @feedback.title,
                                content: @feedback.content,
                                comment: @feedback.comment,
                                responded: @feedback.responded }
    end
    assert_response :redirect

    assert_redirected_to feedback_path(assigns(:feedback))
  end

  test 'feedback#show should provide the feedback for admins' do
    get :show, id: @feedback.id
    assert_response :success

    assert_not_nil assigns(:feedback)
    assert_equal @feedback.title, assigns(:feedback).title
    assert_equal @feedback.content, assigns(:feedback).content
    assert_equal @feedback.comment, assigns(:feedback).comment
    assert_equal @feedback.responded, assigns(:feedback).responded
  end

  test 'feedback#edit should have no route' do
    assert_raises(ActionController::UrlGenerationError) \
      { get :edit, id: @feedback.id }
  end

  test 'feedback#update should have no route' do
    assert_raises(ActionController::UrlGenerationError) do
      patch :update, id: @feedback.id,
                     feedback: { title: @feedback.title,
                                 content: @feedback.content,
                                 comment: @feedback.comment,
                                 responded: @feedback.responded }
    end
  end

  test 'feedback#destroy should mark the feedback as responed to for admins' do
    Feedback.find(@feedback.id).update(responded: false)
    assert_difference('Feedback.count', 0) do
      delete :destroy, id: @feedback.id
    end
    assert_response :redirect
    assert_equal true, Feedback.find(@feedback.id).responded
    assert_redirected_to feedback_path(@feedback)
  end
end
