require 'rails_helper'

RSpec.describe "Playlists",type: :request do 
	let(:user) {create(:user)}
	let(:artist){create(:artist)}
	let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	describe "GET /api/v1/playlists" do 
		it "should need access token " do 
			get '/api/v1/playlists'
			expect(response).to have_http_status(:unauthorized)
		end

		it "should return all playlists" do 
			get  '/api/v1/playlists',params: {access_token:user_token.token}
			expect(response).to have_http_status(:ok)
		end 
	end 


	describe "POST /api/v1/playlists" do 
		it "requires authentication" do 
	    	post '/api/v1/playlists',params: {title:nil}
	    	expect(response).to have_http_status(:unauthorized)
	    end 

	    let(:token) {instance_double('Doorkeeper::AccessToken')}
	    let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	     it "creates a new playlist and redirects to the playlists index" do 
	     	expect{
					post '/api/v1/playlists',params: {access_token:user_token.token,playlist:{title:"Hello",description:"all"}}
				}.to change(Playlist,:count).by(1)
	    end

	    it "should not allow artists to create it" do 
	    	
					post '/api/v1/playlists',params: {access_token:artist_token.token,playlist:{title:"Hello",description:"all"}}
				expect(response).to have_http_status(:unauthorized)
		end
	end 

	# describe "GET #show" do 
    # 	let(:token) {instance_double('Doorkeeper::AccessToken')}

    # 	before do 
    # 		allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
    # 	end 

    #     let(:artist){create(:artist)}
    #     let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
    #     let(:image){create(:image,imageable:album)}
    #     let(:user){create(:user)}
    #     let(:album){create(:album,artist:artist)}

    #     it "assigns the requested album to albums" do 
    #     	get api_v1_album_path(album),params: {id:album.id,access_token:artist_token.token}
    #         expect(response).to have_http_status(:ok)
    #     end 

    #     it "assigns the current album's image to images" do 
    #     	get api_v1_album_path(album),params:{id:album.id,access_token:artist_token.token}
    #     	expect(response).to have_http_status(:ok)
    #     end 

    #     it "renders the show template" do 
    #     	get api_v1_album_path(album),params:{id:album.id,access_token:artist_token.token}
    #     	expect(response).to have_http_status(:ok)
    #     end 
    # end
end