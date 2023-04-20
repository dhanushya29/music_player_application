ActiveAdmin.register Playlist do

 filter :title
 filter :description
 permit_params :title,:description
  
end
