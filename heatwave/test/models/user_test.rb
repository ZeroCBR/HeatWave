require 'test_helper'
##
# Mostly tests to make sure you can't register for SMS
# without having a proper phone number
class UserTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  setup do
    @user1 = User.new(email: 'asanchez@email.com',
                      encrypted_password: '123',
                      f_name: 'Alice',
                      l_name: 'Sanchez',
                      gender: 'F',
                      age: 20,
                      message_type: 'phone',
                      phone: '0400400001',
                      location: @mildura)
    @user2 = User.new(email: 'bobr@email.com',
                      encrypted_password: 'abc',
                      f_name: 'Bob',
                      l_name: 'Roberts',
                      gender: 'M',
                      age: 30,
                      message_type: 'email',
                      location: @mildura)
  end

  test 'adding an sms user with . in phone details' do
    third_user = @user2.clone
    third_user.phone = '0400400.123'
    third_user.email = third_user.email + '3'
    assert_not third_user.save, 'Saved an sms User with a . in their phone'
  end

  test 'adding an sms user with + in phone details' do
    fourth_user = @user2.clone
    fourth_user.phone = '+0400400123'
    fourth_user.email = fourth_user.email + '4'
    assert_not fourth_user.save, 'Saved an sms User with a + in their phone'
  end

  test 'changing an email user over to an sms user without updating phone' do
    sixth_user = @user1.clone
    sixth_user.message_type = 'phone'
    sixth_user.email = sixth_user.email + '6'
    assert_not sixth_user.save, 'could not correctly update a user to use sms'
  end
end
