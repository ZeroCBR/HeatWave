# Rule model
class Rule < ActiveRecord::Base
  has_many :attributes_rules
  has_many :a_r, through: :attributes_rules, class_name: 'Attribute'
  has_many :messages

  ##
  # Determines whether a particular weather event satisfies
  # this rule.
  #
  # ==== Parameters
  #
  # * +weather+ - a Weather model object.
  #
  # ==== Returns
  #
  # +true+ if +weather+ satisfies this, otherwise +false+.
  #
  def satisfied_by?(weather)
    mean = weather.location.mean_for(weather.date)
    weather.high_temp >= mean + delta
  end
end
