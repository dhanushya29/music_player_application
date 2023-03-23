class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.bigint :album_id
      t.string :duration
      t.text :lyrics

      t.timestamps
    end
  end
end
