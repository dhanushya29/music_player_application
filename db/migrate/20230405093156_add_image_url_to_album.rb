class AddImageUrlToAlbum < ActiveRecord::Migration[6.0]
  def change
    add_column :albums, :image_url, :string
  end
end
