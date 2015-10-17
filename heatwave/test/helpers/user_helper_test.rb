require 'test_helper'

# Test the feedback controller with a normal user.
class UserFormBuilderTest < ActionView::TestCase
  setup do
    @template = Object.new
    @template.extend ActionView::Helpers::FormHelper
    @template.extend ActionView::Helpers::FormOptionsHelper
    @it = UserFormBuilder.new 'User', User.new, @template, {}
  end

  test 'UserHelper#label(:f_name) should return "Given Name"' do
    assert_equal '<label for="User_f_name">Given Name</label>',
                 @it.label(:f_name)
  end

  test 'UserHelper#label(:l_name) should return "Family Name"' do
    assert_equal '<label for="User_l_name">Family Name</label>',
                 @it.label(:l_name)
  end

  test 'UserHelper#label(:admin_access) should return "Administrator?"' do
    assert_equal '<label for="User_admin_access">Administrator?</label>',
                 @it.label(:admin_access)
  end
end
