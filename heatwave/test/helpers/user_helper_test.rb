require 'test_helper'

# Test the feedback controller with a normal user.
class UserFormBuilderTest < ActionView::TestCase
  setup do
    @it = UserFormBuilder.new 'User', User.new, nil, {}
  end

  test 'UserHelper#label(:f_name) should return "Given Name"' do
    assert_equal 'Given Name', @it.label(:f_name)
  end

  test 'UserHelper#label(:l_name) should return "Family Name"' do
    assert_equal 'Family Name', @it.label(:l_name)
  end
end
