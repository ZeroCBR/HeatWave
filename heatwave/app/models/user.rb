# Usermodel
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :username, uniqueness: true
  validates :location, presence: true

  belongs_to :location
  has_many :users_attributes
  has_many :u_a, through: :users_attributes, class_name: 'Attribute'
  has_many :feedbacks
  has_many :histories
  has_many :messages
end
