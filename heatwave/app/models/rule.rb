class Rule < ActiveRecord::Base
  has_many :attributes_rules
  has_many :a_r, through: :attributes_rules, class_name: 'Attribute'
end
