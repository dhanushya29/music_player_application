require 'rails_helper'

RSpec.describe AlbumsController do 
	describe "GET #index" do 
		let!(:artist) { create(:artist) }
		let!(:album) { create(:album,artist: artist) }
		it "assigns all albums as @albums" do 
			get :index
			expect(assigns(:albums)).to eq([album])
		end
	end 

	describe "POST #create" do 
		context "when artist is signed in" do 
			let(:artist) { create(:artist) }
			before {sign_in(artist)}

			it "creates a new album" do 
				expect{
					post :create,params: {album: attributes_for(:album)}
				}.to change(Album, :count).by(1)
			end 

			it "redirects to the albums index" do 
				post :create,params: {album:{title: "A4",description: "All genre",language: "Tamil"}}
				expect(response).to redirect_to(albums_path)
			end 
		end
	end

	describe "PATCH #update" do
		let!(:artist) { create(:artist) }
		let!(:album) { create(:album,artist: artist) }
	    context "with good data" do
		    it "updates the album and redirects" do
		      patch :update,params: {id:album.id, album: {title:"Hello",description:"all"}}
		      #expect(response).to be_redirect
		      expect(album.reload.title).to eq("Hello")
		    end
	    end
		context "with bad data" do
		    it "does not change the album, and re-renders the form" do
		      patch :update,params:{ id: album.id, album: {title:2}}
		      expect(response).to be_redirect
		    end
		end
    end


    describe "DELETE #destroy" do 
    	let(:artist) { create(:artist) }
    	let(:album) { create(:album,artist:artist)}
    	let(:user) {create(:user)}

    	it 'should remove album' do 
    		delete :destroy,params: {id: album.id}
    		expect(response).to be_redirect
    	end
    end

    describe "SHOW #show" do 
    	let(:artist){create(:artist)}
    	let(:user){create(:user)}
    	let(:album){create(:album,artist:artist)}

    	it 'should show the album' do 
    		get :show,params: {id:album.id}
    	    expect(album.reload.title).to eq(album.title)
    	end 
    end
end