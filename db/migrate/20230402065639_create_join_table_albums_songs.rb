class CreateJoinTableAlbumsSongs < ActiveRecord::Migration[6.0]
  def change
    create_join_table :albums,:songs ,:null=>false
  end
end
