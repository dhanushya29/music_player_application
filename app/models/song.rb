class Song < ApplicationRecord
	has_and_belongs_to_many :playlists ,dependent: :destroy
	has_and_belongs_to_many :albums ,dependent: :destroy
    belongs_to :artist

    
	validates :title,:duration,:lyrics,presence: true
end
