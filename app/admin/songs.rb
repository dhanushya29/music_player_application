ActiveAdmin.register Song do

  permit_params :title,:duration,:lyrics
  filter :title
  filter :duration
  filter :lyrics
  
end
