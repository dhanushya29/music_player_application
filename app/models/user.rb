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

  validates :username,:phone ,presence: true
  validates_format_of :username,:with=> /\A[^0-9`!@#\$%\^&*+_=]+\z/
  validates :username,:presence=>true,:length=>{:minimum=>10 ,:maximum=>16}
  validates :phone,:uniqueness=>true,:numericality=>true,:length=>{:minimum=>5,:maximum=>15}

  validates :email,format: URI::MailTo::EMAIL_REGEXP
  
end
