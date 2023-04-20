require 'rails_helper'

RSpec.describe "Songs",type: :request do 
	let(:artist) {create(:artist)}
	let(:user) {create(:user)}
	let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
	let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	describe "GET /api/v1/songs" do 
		let!(:song){create(:song,artist:artist)}
		it "should need access token " do 
			get '/api/v1/songs'
			expect(response).to have_http_status(:unauthorized)
		end

		it "should return all songs of artist" do 
			get '/api/v1/songs',params: {access_token:artist_token.token}
			expect(JSON.parse(response.body)['Songs']).to eq([song.as_json.stringify_keys])
		end

		it "should return all songs" do 
			get  '/api/v1/songs',params: {access_token:user_token.token}
			expect(JSON.parse(response.body)['Songs']).to eq([song.as_json.stringify_keys])
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

        let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:user){create(:user)}
        let(:song){create(:song,artist:artist)}

        it "assigns the requested song to songs" do 
        	get api_v1_song_path(song),params: {id:song.id,access_token:artist_token.token}
            expect(JSON.parse(response.body)["song"]).eql?(song)
        end 

        it "renders the show template" do 
        	get api_v1_song_path(song),params:{id:song.id,access_token:artist_token.token}
        	expect(response).to have_http_status(:ok)
        end 
    end   

    describe "PUT#update" do 
    	it "requires authentication" do 
    		put api_v1_song_path(song),params:{id:song.id}
    		expect(response).to have_http_status(:unauthorized)
    	end 

        let(:token) {instance_double('Doorkeeper::AccessToken')}
    	let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:image){create(:image,imageable:album)}
        let(:user){create(:user)}
        let(:song){create(:song,artist:artist)}

        it "updates a particular album" do 
        	put api_v1_song_path(song),params:{id:song.id,access_token:artist_token.token,title:"Good"}
        	expect(JSON.parse(response.body)["album"]).eql?(song)
        end
    end 


    describe "DELETE #destroy" do 
    	it "requires authentication" do 
    		delete api_v1_song_path(song),params:{id:song.id}
    		expect(response).to have_http_status(:unauthorized)
    	end 

    	let(:token) {instance_double('Doorkeeper::AccessToken')}
    	let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:song){create(:song,artist:artist)}

        it "deletes song" do 
        	delete api_v1_song_path(song),params:{id:song.id,access_token:artist_token.token}
        	expect(response).to have_http_status(200)
        end 
    end
end