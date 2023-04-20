class AddArtistIdToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :artist_id, :bigint
  end
end
