ActiveAdmin.register Image do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   permit_params :image_url, :imageable_type, :imageable_id
  scope :user,->{ where(:imageable_type => 'User')}
  scope :artist,->{ where(:imageable_type => 'Artist')}
  scope :album,->{ where(:imageable_type => 'Album')}
  scope :playlist,->{ where(:imageable_type => 'Playlist')}
  
end
