require 'rails_helper'

RSpec.describe "Artist",type: :request do 
    # let(:artist){create(:artist)}

    # let(:artist_token){create(:doorkeeper_access_token,resource_owner_id: artist.id)} 
	describe "GET #new" do 
		let(:token) {instance_double('Doorkeeper::AccessToken')}

		before do 
			allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
		end 

		let!(:artist){Artist.new}
		before{get api_v1_artists_path}
		it "assigns a new artist to artists" do 
			expect(JSON.parse(response.body)["id"]).to eq(artist.id)
		end 

		it "renders the new template" do 
			expect(response).to have_http_status(:ok)
		end 
	end

	describe "POST #create" do 
		let(:token){instance_double('Doorkeeper::AccessToken')}
        let(:artist){create(:artist)}
        let(:artist_token){create(:doorkeeper_access_token,resource_owner_id: artist.id)} 
        before do 
			allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
		end 
		context "with valid params" do 

			it "creates a new artist" do 
				expect{
					post '/api/v1/artists',params: {accesss_token:artist_token,artist:{name:"dua",email:"dua@gmail.com",region:"Albania",image_url:"https://i.scdn.co/image/ab6761610000e5ebd42a27db3286b58553da8858",password:"123456"}}
				}.to change(Artist,:count).by(1)
			end 
		end 
	end
end 

