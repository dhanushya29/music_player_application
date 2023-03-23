class CreateAlbums < ActiveRecord::Migration[6.0]
  def change
    create_table :albums do |t|
      t.string :title
      t.bigint :artist_id
      t.text :description
      t.string :language

      t.timestamps
    end
  end
end
