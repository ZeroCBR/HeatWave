class Attribute < ActiveRecord::Base
	has_many :attributes_rules
	has_many :a_r, :through => :attributes_rules, :class_name => "Rule"
	has_many :users_attributes
	has_many :u_a, :through => :users_attributes, :class_name => "User"
end
