class Dropplaylistuser < ActiveRecord::Migration[6.0]
  def change
     drop_table :playlist_user
  end
end
