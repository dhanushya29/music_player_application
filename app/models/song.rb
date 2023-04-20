class Song < ApplicationRecord
	has_and_belongs_to_many :playlists ,dependent: :destroy
	has_and_belongs_to_many :albums ,dependent: :destroy
    belongs_to :artist
    after_validation :normalize_title,on: :create
    
	validates :title,:duration,:lyrics,presence: true

	private 

	def normalize_title
		self.title = title.upcase.titleize
	end
end
