class Song < ApplicationRecord
	belongs_to :album 
	has_and_belongs_to_many :playlists
    belongs_to :artist
	validates :title,:duration,:lyrics,presence: true
end
