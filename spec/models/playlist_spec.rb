require 'rails_helper'

RSpec.describe Playlist,type: :model do 
	describe 'Validation testing' do 

		context 'While creating playlist' do
			let(:user) {create(:user)}
			let(:playlist) {create(:playlist,user: user)}

			it 'should be valid playlist with all attributes' do 
				expect(playlist.valid?).to eq(true)
			end

			it 'should belong to a user' do 
				expect(playlist.user).to eq(user)
			end

			it 'is not valid for playlist without title' do 
			    playlist.title=nil
			    expect(playlist.valid?).to eq(false)
			end

			it 'is not valid for playlist without description' do 
            	playlist.description = nil
            	expect(playlist.valid?).to eq(false)
            end
		end 
		describe "Associations" do 
			let(:user) {create(:user)}
			let(:playlist) {create(:playlist, user: user)}
            let(:song) {build(:song,artist: artist)}
            let(:artist){build(:artist)}
            let(:album){build(:album,artist: artist)}


			it 'belongs to a user' do 
				expect(playlist.user).to eq(user)
			end 

			it 'has and belongs to many songs' do 
				playlist.songs << song
				expect(playlist.songs).to include(song)
			end 

			it 'has and belongs to many albums' do 
				playlist.albums << album
				expect(playlist.albums).to include(album)
			end 


		end
	end
	describe "Callback testing" do 
    	let(:user){create(:user)}
		let(:playlist) {create(:playlist,user:user)}
        
		context "normalize title" do 
			it "does the capitalisation" do 
				playlist.validate!
				expect(playlist.reload.title).to eq "Hello"
			end
		end

		context "deleting songs" do 
			it "should destroy songs" do 
				expect(playlist.songs.empty?).to eq(true)
			end
		end

		context "deleting albums" do 
			it "should destroy albums" do 
				expect(playlist.albums.empty?).to eq(true)
			end
		end
	end
end 
