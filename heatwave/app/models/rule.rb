# Rule model
class Rule < ActiveRecord::Base
  has_many :attributes_rules
  has_many :a_r, through: :attributes_rules, class_name: 'Attribute'
  has_many :messages

  validates :name, presence: true
  validates :activated, presence: true
  validates :delta, presence: true
  validates :duration, presence: true, numericality: { only_integer: true,
                                                       greater_than: 0 }
  validates :key_advice, presence: true
  validates :full_advice, presence: true

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
    return false unless activated
    mean = weather.location.mean_for(weather.date)
    weather.high_temp >= mean + delta
  end
end
