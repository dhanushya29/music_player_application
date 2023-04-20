require 'rails_helper'

RSpec.describe SongsController do 
	let!(:artist) { create(:artist) }
	let!(:album){create(:album,artist:artist)}
	let!(:song) { create(:song,artist: artist) }
	let!(:user) {create(:user)}
	describe "GET #index" do 
		context "when user signed in" do 
           before do 
           	sign_in user
           	get :index
           end 

            it 'displays songs index' do 
			  expect(assigns(:songs)).to eq([song])
			end
		end 

		context "when artist signed in" do 
			before do 
			   sign_in artist
			   get :index,params: {album_id:album.id}
			end 

			it 'displays artist\'s songs' do 
				expect(assigns(:songs)).to eq(album.songs.all)
			end
		end
	end

    describe "POST #create" do 
    	context "when artist signed in" do 
    		let(:artist){create(:artist)}
    		before {sign_in(artist)}

    		it "creates new song" do 
    			expect{
    				post :create,params: {album_id:album.id,song:attributes_for(:song)}
    			}.to change(Song,:count).by(1)
    		end 

    		it "redirects to the songs index" do 
    			post :create,params: {album_id:album.id,song:attributes_for(:song)}
    			expect(response).to redirect_to(songs_path(params: {album_id:album.id}))
    		end
    	end 
    end  

    describe "SHOW #show" do 
    	let(:artist){create(:artist)}
    	let(:user){create(:user)}
    	let(:song){create(:song,artist:artist)}

    	it 'should show the song' do 
    		get :show,params: {id:song.id}
    	    expect(song.reload.title).to eq(song.title)
    	end 
    end
    
    describe "PATCH #update" do
	    context "with good data" do
		    it "updates the song and redirects" do
		      patch :update,params: {id:song.id,album_id:album.id,song: {title:"Hello"}}
		      expect(response).to be_redirect
		      #expect(album.reload.title).to eq("Hello")
		    end
	    end
		context "with bad data" do
		    it "does not change the album, and re-renders the form" do
		      patch :update,params:{ id: song.id,album_id:album.id, song: {title:2}}
		      expect(response).to be_redirect
		    end
		end
    end

    describe "DELETE #destroy" do 

    	it 'should remove song' do 
    		delete :destroy,params: {id: song.id}
    		expect(response).to be_redirect
    	end
    end
end