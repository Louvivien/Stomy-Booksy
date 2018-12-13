class Establishment < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :siret, presence: true
  validates :address, presence: true
  validates :phone, presence: true

  has_and_belongs_to_many :teachers
  has_many :resources, dependent: :destroy
  has_many :events, through: :resources
  has_one_attached :avatar

  geocoded_by :address
  after_validation :geocode

  def upcoming_events
    events.order(start_time: :desc).select { |e| e.start_time > (DateTime.now) }
  end

  after_create :welcome_send, :avatar_attach

  def avatar_attach
    temp_user = self
    temp_user.avatar.attach(io: File.open("app/assets/images/neutral.jpeg"), filename: 'avatar')
  end


  def welcome_send
    ContactMailer.welcome_send(self).deliver_now
  end
  
end
