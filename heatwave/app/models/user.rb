class User < ActiveRecord::Base
  validates :username, uniqueness: true
  has_many :users_attributes
  has_many :u_a, through: :users_attributes, class_name: 'Attribute'
  has_many :feedbacks
  has_many :histories
end
