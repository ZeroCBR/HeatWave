require 'test_helper'

# Test the rule controller with a normal user.
class NormalRulesControllerTest < ActionController::TestCase
  setup do
    @rule = rules(:one)
    @controller = RulesController.new
    sign_in(users(:one))
  end

  test 'rule#index should prevent access for normal users' do
    get :index
    assert_response :redirect
    assert_nil assigns(:rules)
  end

  test 'rule#new should prevent access for normal users' do
    get :new
    assert_response :redirect
  end

  test 'rule#create should not create a rule, but redirect for normal users' do
    assert_difference('Rule.count', 0) do
      post :create, rule: { activated: @rule.activated,
                            name: @rule.name,
                            delta: @rule.delta,
                            duration: @rule.duration,
                            key_advice: @rule.key_advice,
                            full_advice: @rule.full_advice }
    end

    assert_response :redirect
  end

  test 'rule#show should allow restricted access for normal users' do
    get :show, id: @rule.id
    assert_response :success

    assert_not_nil assigns(:rule)
    assert_equal @rule.name, assigns(:rule).name
    assert_equal @rule.key_advice, assigns(:rule).key_advice
    assert_equal @rule.full_advice, assigns(:rule).full_advice
  end

  test 'rule#edit should prevent access for normal users' do
    get :edit, id: @rule.id
    assert_response :redirect
  end

  test 'rule#update should prevent access for normal users' do
    patch :update, id: @rule.id, rule: { activated: !@rule.activated,
                                         name: @rule.name + 'a',
                                         delta: @rule.delta + 1,
                                         duration: @rule.duration + 1,
                                         key_advice: @rule.key_advice + 'a',
                                         full_advice: @rule.full_advice + 'a' }
    assert_response :redirect

    result = Rule.find(@rule.id)
    assert_equal result.activated, @rule.activated
    assert_equal result.name, @rule.name
    assert_equal result.delta, @rule.delta
    assert_equal result.duration, @rule.duration
    assert_equal result.key_advice, @rule.key_advice
    assert_equal result.full_advice, @rule.full_advice
  end

  test 'rule#destroy should prevent access for normal users' do
    Rule.find(@rule.id).update(activated: true)
    assert_difference('Rule.count', 0) do
      delete :destroy, id: @rule.id
    end
    assert_equal true, Rule.find(@rule.id).activated

    assert_response :redirect
  end
end

# Test the rule controller with an admin user.
class AdminRulesControllerTest < ActionController::TestCase
  setup do
    @rule = rules(:one)
    @controller = RulesController.new
    sign_in(users(:two))
  end

  test 'rule#index should succeed providing rules for admins' do
    get :index
    assert_response :success
    assert_not_nil assigns(:rules)
    assert_equal Rule.count, assigns(:rules).length
  end

  test 'rule#new should succeed providing an empty rule for admins' do
    get :new
    assert_response :success

    assert_not_nil assigns(:rule)
    assert_not assigns(:rule).activated
    assert_nil assigns(:rule).name
    assert_nil assigns(:rule).delta
    assert_nil assigns(:rule).duration
    assert_nil assigns(:rule).key_advice
    assert_nil assigns(:rule).full_advice
  end

  test 'rule#create should create a rule and redirect for admins' do
    assert_difference('Rule.count') do
      post :create, rule: { activated: @rule.activated,
                            name: @rule.name,
                            delta: @rule.delta,
                            duration: @rule.duration,
                            key_advice: @rule.key_advice,
                            full_advice: @rule.full_advice }
    end
    assert_response :redirect

    assert_redirected_to rule_path(assigns(:rule))
  end

  test 'rule#show should provide the rule for admins' do
    get :show, id: @rule.id
    assert_response :success

    assert_not_nil assigns(:rule)
    assert_equal assigns(:rule).activated, @rule.activated
    assert_equal assigns(:rule).name, @rule.name
    assert_equal assigns(:rule).delta, @rule.delta
    assert_equal assigns(:rule).duration, @rule.duration
    assert_equal assigns(:rule).key_advice, @rule.key_advice
    assert_equal assigns(:rule).full_advice, @rule.full_advice
  end

  test 'rule#edit should provide a form for the rule for admins' do
    get :edit, id: @rule.id
    assert_response :success

    assert_not_nil assigns(:rule)
    assert_equal assigns(:rule).activated, @rule.activated
    assert_equal assigns(:rule).name, @rule.name
    assert_equal assigns(:rule).delta, @rule.delta
    assert_equal assigns(:rule).duration, @rule.duration
    assert_equal assigns(:rule).key_advice, @rule.key_advice
    assert_equal assigns(:rule).full_advice, @rule.full_advice
  end

  test 'rule#update should update the rule for admins' do
    original_activated = @rule.activated
    patch :update, id: @rule.id, rule: { activated: !original_activated,
                                         name: @rule.name + 'a',
                                         delta: @rule.delta + 1,
                                         duration: @rule.duration + 1,
                                         key_advice: @rule.key_advice + 'a',
                                         full_advice: @rule.full_advice + 'a' }
    assert_response :redirect

    result = Rule.find(@rule.id)
    assert_equal result.activated, !original_activated
    assert_equal result.name, @rule.name + 'a'
    assert_equal result.delta, @rule.delta + 1
    assert_equal result.duration, @rule.duration + 1
    assert_equal result.key_advice, @rule.key_advice + 'a'
    assert_equal result.full_advice, @rule.full_advice + 'a'
  end

  test 'rule#destroy should deactivate the rule for admins' do
    Rule.find(@rule.id).update(activated: true)
    assert_difference('Rule.count', 0) do
      delete :destroy, id: @rule.id
    end
    assert_response :redirect
    assert_equal false, Rule.find(@rule.id).activated
    assert_redirected_to rule_path(@rule)
  end
end
