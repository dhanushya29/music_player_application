class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :playlists
  has_many :playlist_follows
  has_many :followers,through: :playlist_follows,source: :user
  has_one :image ,as: :imageable
  accepts_nested_attributes_for :image 

  validates :username,:presence=>true,:length=>{:minimum=>4 ,:maximum=>16}
  validates :name, format: { with: /\A[a-zA-Z0-9]+\Z/ ,message: 'cannot include whitespaces'}
  validates :phone,   :presence => {:message => 'hello user, bad operation!'},
                     :numericality => true,
                     :length => { :minimum => 10, :maximum => 15 }

  validates :email,format: URI::MailTo::EMAIL_REGEXP

  def self.authenticate(email,password)
    user=User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil  
  end
end
