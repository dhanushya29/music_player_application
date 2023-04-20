class Album < ApplicationRecord
	belongs_to :artist 
    has_and_belongs_to_many :songs ,dependent: :destroy
    has_and_belongs_to_many :playlists,dependent: :destroy
    has_one :image ,as: :imageable,dependent: :destroy
    accepts_nested_attributes_for :image
    after_validation :normalize_title,on: :create
    before_destroy :destroy_songs
	    
    
	validates :title,:language,:description , presence: {message:"must be given"}
	
	def self.search(search_album,serach_song)
		return scoped unless search_album.present? || serach_song.present?
		where(['album_name LIKE ? AND song LIKE ?', "%#{search_album}%","%#{serach_song}%"])
	end
	
	private 

	def destroy_songs 
    	self.songs.delete
    end

	def normalize_title
		self.title = title.upcase.titleize
	end
end
