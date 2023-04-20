class PlaylistFollow < ApplicationRecord
  validates :user_id ,presence: true
  validates :playlist_id,presence: true
  validates_uniqueness_of :user_id,scope: [:playlist_id]
  
  belongs_to :playlist
  belongs_to :user
end
