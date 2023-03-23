class Playlist < ApplicationRecord
	belongs_to :user 
	has_and_belongs_to_many :songs
	has_many :playlist_follows
	has_many :followers,through: :playlist_follows,source: :user
	has_one :image ,as: :imageable

	validates :title,:description,presence: true
end
