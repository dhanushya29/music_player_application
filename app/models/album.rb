class Album < ApplicationRecord
	belongs_to :artist 
    has_and_belongs_to_many :songs ,dependent: :destroy
    has_and_belongs_to_many :playlists
    has_one :image ,as: :imageable
    accepts_nested_attributes_for :image
    after_validation :normalize_title,on: :create


	validates :title,:language,:description , presence: {message:"must be given"}
	
	private 

	def normalize_title
		self.title = title.upcase.titleize
	end
end
