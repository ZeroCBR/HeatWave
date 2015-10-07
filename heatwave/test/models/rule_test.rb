require 'test_helper'
# Rule model test
class RuleTest < ActiveSupport::TestCase
  test 'should not save rule without name' do
    rule = Rule.new('activated' => 't', 'delta' => 1,
                    'duration' => 1, 'key_advice' => 'key_advice',
                    'full_advice' => 'full_advice',
                    'created_at' => Time.zone.now,
                    'updated_at' => Time.zone.now)
    assert_not rule.save, 'Saved the rule without a name'
  end

  test 'should not save rule without delta' do
    rule = Rule.new('name' => 'High temperature', 'activated' => 't',
                    'duration' => 1, 'key_advice' => 'key_advice',
                    'full_advice' => 'full_advice',
                    'created_at' => Time.zone.now,
                    'updated_at' => Time.zone.now)
    assert_not rule.save, 'Saved the rule without a delta'
  end

  test 'should not save rule without duration' do
    rule = Rule.new('name' => 'High temperature', 'activated' => 't',
                    'delta' => 1, 'key_advice' => 'key_advice',
                    'full_advice' => 'full_advice',
                    'created_at' => Time.zone.now,
                    'updated_at' => Time.zone.now)
    assert_not rule.save, 'Saved the rule without a duration'
  end

  test 'should not save rule with duration less than 1' do
    rule = Rule.new('name' => 'High temperature', 'activated' => 't',
                    'delta' => 1,
                    'duration' => -1, 'key_advice' => 'key_advice',
                    'full_advice' => 'full_advice',
                    'created_at' => Time.zone.now,
                    'updated_at' => Time.zone.now)
    assert_not rule.save, 'Saved the rule with duration less than 1'
  end

  test 'should not save rule without key_advice' do
    rule = Rule.new('name' => 'High temperature', 'activated' => 't',
                    'delta' => 1,
                    'duration' => 1, 'full_advice' => 'full_advice',
                    'created_at' => Time.zone.now,
                    'updated_at' => Time.zone.now)
    assert_not rule.save, 'Saved the rule without a key_advice'
  end

  test 'should not save rule without full_advice' do
    rule = Rule.new('name' => 'High temperature', 'activated' => 't',
                    'delta' => 1, 'duration' => 1,
                    'key_advice' => 'key_advice',
                    'created_at' => Time.zone.now,
                    'updated_at' => Time.zone.now)
    assert_not rule.save, 'Saved the rule without a full_advice'
  end
end
