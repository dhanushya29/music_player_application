json.extract! song, :id, :title, :album_id, :duration, :lyrics, :created_at, :updated_at
json.url song_url(song, format: :json)
