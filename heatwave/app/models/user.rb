## Model for storing users, including admins and vulnerable individuals.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, allow_blank: false,
                    uniqueness: { case_sensitive: false }
  validates :location, presence: true
  validates :f_name, presence: true, allow_blank: false
  validates :l_name, presence: true, allow_blank: false
  validates :gender, presence: true, allow_blank: false
  validates :age, presence: true
  validates :age, numericality: { only_integer: true,
                                  greater_than_or_equal_to: 18,
                                  message: 'must be at least 18 to register.' }
  validates :message_type, inclusion: { in: %w(email phone) }
  validate :phone_number_appropriate?

  belongs_to :location
  has_many :feedbacks
  has_many :histories
  has_many :messages

  def phone_number_appropriate?
    return true unless message_type == 'phone'
    return true if phone.to_s.match(/\A04\d{8}\Z/)
    errors[:phone] << ' number must be Australian mobile' \
      ' number of the form 04XXXXXXXX'
  end
end
