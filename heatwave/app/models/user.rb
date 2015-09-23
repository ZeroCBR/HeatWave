# Usermodel
class User < ActiveRecord::Base
  validates :username, uniqueness: true
  validates :location, presence: true

  belongs_to :location
  has_many :users_attributes
  has_many :u_a, through: :users_attributes, class_name: 'Attribute'
  has_many :feedbacks
  has_many :histories
  has_many :messages
end
