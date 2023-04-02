class Artist < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_many :albums 
    has_many :songs
    has_one :image ,as: :imageable
    accepts_nested_attributes_for :image
    #validates :name,:region ,presence: true
end
