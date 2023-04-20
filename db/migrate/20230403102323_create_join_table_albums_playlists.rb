class CreateJoinTableAlbumsPlaylists < ActiveRecord::Migration[6.0]
  def change
    create_join_table :albums,:playlists,:null => false
  end
end
