class CreateJoinTablePlaylistsSongs < ActiveRecord::Migration[6.0]
  def change
    create_join_table :playlists,:songs ,:null=>false
  end
end
