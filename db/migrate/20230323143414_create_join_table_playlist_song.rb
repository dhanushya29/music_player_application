class CreateJoinTablePlaylistSong < ActiveRecord::Migration[6.0]
  def change
    create_join_table :playlist,:song ,:null => false
  end
end
