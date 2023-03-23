class CreatePlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :playlists do |t|
      t.bigint :user_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
