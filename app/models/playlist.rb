class Playlist < ApplicationRecord
	belongs_to :user 
	has_and_belongs_to_many :albums,dependent: :destroy
	has_and_belongs_to_many :songs,dependent: :destroy
	has_many :playlist_follows
	has_many :followers,through: :playlist_follows,source: :user
	has_one :image ,as: :imageable
	accepts_nested_attributes_for :image 
	

	validates :title,:description,presence: true
end
