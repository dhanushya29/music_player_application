require 'rails_helper'

RSpec.describe "Albums",type: :request do 
	let(:artist) {create(:artist)}
	let(:user) {create(:user)}
	let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
	let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}

	describe "GET /api/v1/albums" do 
		let!(:album){create(:album,artist:artist)}
		it "should need access token " do 
			get '/api/v1/albums'
			expect(response).to have_http_status(:unauthorized)
		end

		it "should return all albums of artist" do 
			get '/api/v1/albums',params: {access_token:artist_token.token}
			expect(JSON.parse(response.body)['Albums']).to eq([album.as_json.stringify_keys])
		end

		it "should return all albums" do 
			get  '/api/v1/albums',params: {access_token:user_token.token}
			expect(JSON.parse(response.body)['Albums']).to eq([album.as_json.stringify_keys])
		end 
	end 


	describe "POST /api/v1/albums" do 
		it "requires authentication" do 
	    	post '/api/v1/albums',params: {title:nil}
	    	expect(response).to have_http_status(:unauthorized)
	    end 

	    let(:token) {instance_double('Doorkeeper::AccessToken')}
	    let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	     it "creates a new album and redirects to the albums index" do 
	     	expect{
					post '/api/v1/albums',params: {access_token:artist_token.token,album:{title:"Hello",description:"all",language:"tamil"}}
				}.to change(Album,:count).by(1)
	    end

	    it "should not allow users to create it" do 
	    	
					post '/api/v1/albums',params: {access_token:user_token.token,album:{title:"Hello",description:"all",language:"tamil"}}
				expect(response).to have_http_status(:forbidden)
		end
	end 

	describe "GET #show" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}
        let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:image){create(:image,imageable:album)}
        let(:user){create(:user)}
        let(:album){create(:album,artist:artist)}

        it "assigns the requested album to albums" do 
        	get api_v1_album_path(album),params: {id:album.id,access_token:artist_token.token}
            expect(JSON.parse(response.body)["album"]).eql?(album)
        end 

        it "assigns the current album's image to images" do 
        	get api_v1_album_path(album),params:{id:album.id,access_token:artist_token.token}
        	expect(response).to have_http_status(:ok)
        end 

        it "renders the show template" do 
        	get api_v1_album_path(album),params:{id:album.id,access_token:artist_token.token}
        	expect(response).to have_http_status(:ok)
        end 
    end

    describe "PUT#update" do 
    	it "requires authentication" do 
    		put api_v1_album_path(album),params:{id:album.id}
    		expect(response).to have_http_status(:unauthorized)
    	end 

        let(:token) {instance_double('Doorkeeper::AccessToken')}
    	let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:image){create(:image,imageable:album)}
        let(:user){create(:user)}
        let(:album){create(:album,artist:artist)}

        it "updates a particular album" do 
        	put api_v1_album_path(album),params:{id:album.id,access_token:artist_token.token,title:"Good"}
        	expect(JSON.parse(response.body)["album"]).eql?(album)
        end
    end 


    describe "DELETE #destroy" do 
    	it "requires authentication" do 
    		delete api_v1_album_path(album),params:{id:album.id}
    		expect(response).to have_http_status(:unauthorized)
    	end 

    	let(:token) {instance_double('Doorkeeper::AccessToken')}
    	let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        let(:album){create(:album,artist:artist)}

        it "deletes album" do 
        	delete api_v1_album_path(album),params:{id:album.id,access_token:artist_token.token}
        	expect(response).to have_http_status(204)
        end 
    end
   
end