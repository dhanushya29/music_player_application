class DropTablePlaylistSong < ActiveRecord::Migration[6.0]
  def change
    drop_table :playlist_song
  end
end
