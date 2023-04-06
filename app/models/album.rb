class Album < ApplicationRecord
	belongs_to :artist 
    has_and_belongs_to_many :songs 
    has_and_belongs_to_many :playlists
    has_one :image ,as: :imageable
    accepts_nested_attributes_for :image


	validates :title,:language , presence: {message:"must be given"}
	
end
