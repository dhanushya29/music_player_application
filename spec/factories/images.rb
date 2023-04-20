FactoryBot.define do
	factory :image do 
		image_url {"https://i.scdn.co/image/ab6761610000e5ebd42a27db3286b58553da8858"}

	    for_user

		trait :for_user do 
			association :imageable,factory: :user 
		end 

		trait :for_artist do 
			association :imageable,factory: :artist
		end 

		trait :for_playlist do 
		    association :imageable,factory: :playlist
		end 

		trait :for_album do 
			association :imageable,factory: :album 
		end 
	end 
end