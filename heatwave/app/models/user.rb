class User < ActiveRecord::Base
	validates :username, uniqueness: true
	has_many :feedbacks
	has_and_belongs_to_many :attributes
end