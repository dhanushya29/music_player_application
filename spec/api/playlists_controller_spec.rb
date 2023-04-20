require 'rails_helper'

RSpec.describe "Playlists",type: :request do 
	let(:user) {create(:user)}
	let(:artist){create(:artist)}
	let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
	let(:user_token) {create(:doorkeeper_access_token,resource_owner_id: user.id)}
	describe "GET /api/v1/playlists" do 

		let!(:playlist){create(:playlist,user:user)}
		it "should need access token " do 
			get '/api/v1/playlists'
			expect(response).to have_http_status(:unauthorized)
		end

		it "should return all playlists" do 
			get  '/api/v1/playlists',params: {access_token:user_token.token}
			expect(JSON.parse(response.body)["Playlists"]).to eq([playlist.as_json.stringify_keys])
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

	describe "GET #show" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

        let(:artist){create(:artist)}
        let(:artist_token) {create(:doorkeeper_access_token,resource_owner_id: artist.id)}
        
        let(:user){create(:user)}
        let(:image){create(:image,imageable:playlist)}
        let(:playlist){create(:playlist,user:user)}

        it "assigns the requested playlist to playlists" do 
        	get api_v1_playlist_path(playlist),params: {id:playlist.id,access_token:user_token.token}
            expect(JSON.parse(response.body)["playlist"]).eql?(playlist)
        end 

        it "assigns the current playlist's image to images" do 
        	get api_v1_playlist_path(playlist),params:{id:playlist.id,access_token:user_token.token}
        	expect(response).to have_http_status(:ok)
        end 

        it "renders the show template" do 
        	get api_v1_playlist_path(playlist),params:{id:playlist.id,access_token:user_token.token}
        	expect(response).to have_http_status(:ok)
        end 
    end


    describe '#insert' do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

    	let(:user){create(:user)}
    	let(:artist){create(:artist)}
    	let(:artist_token){create(:doorkeeper_access_token,resource_owner_id:artist.id)}
    	let(:user_token){create(:doorkeeper_access_token,resource_owner_id: user.id)}
    	let!(:playlist){create(:playlist,user:user)}
    	let!(:song){create(:song,artist:artist)}
    	let!(:album){create(:album,artist:artist)}

    	
    	before do 
    	    playlist.songs<<song 
    	end 

    	context 'when user\'s playlist is present' do 
    		context 'when song is already present' do 
    			it 'should return already added' do 
    				post insert_api_v1_playlists_path,params: {access_token:user_token.token,song_id:song.id,id:playlist.id}
    				expect(response).to have_http_status(:no_content)
    			end 
    		end 

    		context 'when song is not present in playlist' do 
    			it 'should add song to playlist' do 
    				post insert_api_v1_playlists_path,params: {access_token:user_token.token,song_id:song.id,playlist_id:playlist.id}
    			    expect(playlist.reload.songs).to include((song))
    			end 
    		end 
    	end 

    	it "redirects to the songs index page" do 
    		post insert_api_v1_playlists_path,params: {access_token:user_token.token,song_id:song.id,playlist_id:playlist.id}
    		expect(response).to have_http_status(:ok)
    	end 
    end
end