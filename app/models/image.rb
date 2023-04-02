class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :image_url,presence: true

  scope :user,->{ where(:imageable_type => 'User')}
  scope :artist,->{ where(:imageable_type => 'Artist')}
  scope :album,->{ where(:imageable_type => 'Album')}
  scope :playlist,->{ where(:imageable_type => 'Playlist')}
end
