require 'rails_helper'

RSpec.describe "Songs",type: :request do 
	let(:artist) {create(:artist)}
	let(:user) {create(:user)}
	let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
	let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	describe "GET /api/v1/songs" do 
		it "should need access token " do 
			get '/api/v1/songs'
			expect(response).to have_http_status(:unauthorized)
		end

		it "should return all songs of artist" do 
			get '/api/v1/songs',params: {access_token:artist_token.token}
			expect(response).to have_http_status(200)
		end

		it "should return all songs" do 
			get  '/api/v1/songs',params: {access_token:user_token.token}
			expect(response).to have_http_status(:ok)
		end 
	end 


	describe "POST /api/v1/songs" do 
		it "requires authentication" do 
	    	post '/api/v1/songs',params: {title:nil}
	    	expect(response).to have_http_status(:unauthorized)
	    end 

	    let(:token) {instance_double('Doorkeeper::AccessToken')}
	    let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	     it "creates a new song and redirects to the songs index" do 
	     	expect{
					post '/api/v1/songs',params: {access_token:artist_token.token,song:{title:"Hello",duration:"4:08",lyrics:"hi all"}}
				}.to change(Song,:count).by(1)
	     end

	    it "should not allow users to create it" do 
			post '/api/v1/songs',params: {access_token:user_token.token,song:{title:"Hello",duration:"4:08",lyrics:"hi all"}}
		    expect(response).to have_http_status(:unauthorized)
		end
	end 

	describe "GET #show" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

    	before do 
    		allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
    	end 

        let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:user){create(:user)}
        let(:song){create(:song,artist:artist)}

        it "assigns the requested song to songs" do 
        	get api_v1_song_path(song),params: {id:song.id,access_token:artist_token.token}
            expect(response).to have_http_status(:ok)
        end 

        it "renders the show template" do 
        	get api_v1_song_path(song),params:{id:song.id,access_token:artist_token.token}
        	expect(response).to have_http_status(:ok)
        end 
    end   
end