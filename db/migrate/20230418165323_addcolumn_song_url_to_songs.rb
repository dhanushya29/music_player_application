class AddcolumnSongUrlToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :song_url, :string
  end
end
