require 'rails_helper'

RSpec.describe PlaylistsController do 
	describe "GET #index" do 
		let!(:user) { create(:user) }
		let!(:playlist) { create(:playlist,user:user) }
		it "assigns all playlists as @playlists" do 
			get :index
			expect(assigns(:playlists)).to eq([playlist])
		end
	end 

	describe "POST #create" do 
		context "when user signed in" do 
			let(:user) { create(:user) }
			before { sign_in(user) }

		    it "creates a new playlist" do 
		    	expect{
		    		post :create,params: {playlist: attributes_for(:playlist)}
		    	}.to change(Playlist,:count).by(1)
		    end 

		    it "redirects to the playlists index" do 
		    	post :create,params: {playlist: attributes_for(:playlist)}
		    	expect(response).to redirect_to(playlists_path)
		    end 
		end
	end

	describe "#insert" do 
		let(:user){create(:user)}
		let(:playlist){create(:playlist,user:user)}
		let(:artist){create(:artist)}
		let(:song1){create(:song,artist:artist)}

		before do 
			playlist.songs << song1
		end 

		context "when user\'s playlist is present" do 
			context 'when song is already present' do 
				it 'should return already added' do 
					expect(response).not_to be_redirect
				end 
			end 

			context 'when song is not present in playlist' do 
				it 'should add song to playlist' do 
					post :insert,params: {user_id:user.id,song_id:song1.id,playlist_id:playlist.id}
					expect(playlist.reload.songs).to include((song1))
				end 
			end 
		end 
	end

	describe "#insertalbum" do 
		let(:user){create(:user)}
		let(:playlist){create(:playlist,user:user)}
		let(:artist){create(:artist)}
		let(:album1){create(:album,artist:artist)}

		before do 
			playlist.albums << album1
		end 

		context "when user\'s playlist is present" do 
			context 'when album is already present' do 
				it 'should return already added' do 
					expect(response).not_to be_redirect
				end 
			end 

			context 'when album is not present in playlist' do 
				it 'should add album to playlist' do 
					post :insertalbum,params: {user_id:user.id,album_id:album1.id,playlist_id:playlist.id}
					expect(playlist.reload.albums).to include((album1))
				end 
			end 
		end 
	end


	describe "SHOW #show" do 
		let(:user) {create(:user)}
		let(:playlist){ create(:playlist,user:user)}
		let(:artist){create(:artist)}
		let(:song){create(:song,artist:artist)}
		let(:album){create(:album,artist:artist)}

		before do 
			playlist.songs << song 
			playlist.albums << album 
		end 
        
        it 'should show playlist' do 
        	get :show,params: {id:user.id}
        	expect(playlist.reload.title).to eq(playlist.title)
        end 
    end

    describe 'DELETE #destroy' do 
    	let(:user){create(:user)}
    	let(:playlist){create(:playlist,user: user)}
    	let(:artist){create(:artist)}
    	let(:song){create(:song,artist:artist)}
    	let(:album){create(:album,artist:artist)}

    	before do 
    		playlist.songs << song
    		playlist.albums << album
    	end 

        it 'should remove song from playlist' do 
        	delete :destroy,params: {id: user.id,playlist_id:playlist.id,song_id:song.id}
        	expect(response).to redirect_to(playlists_path)
        end 

        it 'should remove album from playlist' do 
        	delete :destroy,params: {id:user.id,playlist_id:playlist.id,album_id:album.id}
        	expect(response).to redirect_to(playlists_path)
        end

        it 'should remove playlist' do 
        	delete :destroy,params: {id:user.id,playlist_id:playlist.id}
        	expect(response).not_to redirect_to(playlist_path(playlist.id))
        end
    end
end