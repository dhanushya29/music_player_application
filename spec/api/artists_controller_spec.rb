require 'rails_helper'

RSpec.describe "Artist",type: :request do 
    
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
					post '/api/v1/artists',params: {access_token:artist_token,artist:{name:"dua",email:"dua@gmail.com",region:"Albania",image_url:"https://i.scdn.co/image/ab6761610000e5ebd42a27db3286b58553da8858",password:"123456"}}
				}.to change(Artist,:count).by(1)
			end 
		end 

		context "with invalid params" do 

			it "does not create a new artist" do 
				expect{
					post '/api/v1/artists',params: {name: nil}
				}.to change(Artist,:count).by(0)
			end 

			it "renders the new template" do 
				post '/api/v1/artists',params: {name:nil,email: "art1@gmail.com"}
				expect(response).to have_http_status(425)
			end
		end 
    end

    describe "GET #show" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

    	before do 
    		allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
    	end 

        let(:artist){create(:artist)}
        let(:image){create(:image,imageable:artist)}

        it "assigns the requested artist to artist" do 
        	get api_v1_artist_path(artist),params: {id:artist.id}
            expect(JSON.parse(response.body)["artist"]).eql?(artist)
        end 

        it "assigns the current artist's image to images" do 
        	get api_v1_artist_path(artist),params:{id:artist.id}
        	expect(JSON.parse(response.body)["artist"]).eql?(artist)
        end 

        it "renders the show template" do 
        	get api_v1_artist_path(artist),params:{id:artist.id}
        	expect(response).to have_http_status(:ok)
        end 
    end 

    describe "GET #index" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

    	before do 
    		allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
    	end 

    	let!(:artist){create(:artist)}
        
        it "assigns all artists as @artists" do 
        	get api_v1_artists_path
        	expect(response).to have_http_status(200)
        end 
    end
end 
