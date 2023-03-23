json.extract! artist, :id, :name, :image_url, :region, :created_at, :updated_at
json.url artist_url(artist, format: :json)
