ActiveAdmin.register Album do

 # config.clear_action_items!
 # actions :all,except: [:edit,:destroy]

 filter :artist
 filter :title
 filter :description
 filter :language
 permit_params :title,:description,:language
 index do 
  selectable_column
  id_column
  column :title
  column :description
  column :language
  column :created_at
  column :updated_at
  actions 
  end 

end
