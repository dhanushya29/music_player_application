class Artist < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	has_many :albums 
    has_many :songs
    has_one :image ,as: :imageable
    accepts_nested_attributes_for :image
    after_validation :normalize_email,on: :create



    validates :region ,presence: true
    validates :name,:presence=>true,:length=>{:minimum => 5 ,:maximum => 16}
    def self.authenticate(email,password)
        artist=Artist.find_for_authentication(email: email)
        artist&.valid_password?(password) ? artist : nil  
    end

    private

    def normalize_email
      self.email = email.downcase
    end
end
