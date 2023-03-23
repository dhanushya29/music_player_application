json.extract! playlist, :id, :user_id, :title, :description, :created_at, :updated_at
json.url playlist_url(playlist, format: :json)
