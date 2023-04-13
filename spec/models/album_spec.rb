require 'rails_helper'

RSpec.describe Album,type: :model do 
	describe 'Validation testing' do 

		context 'While creating album' do
			let(:artist){create(:artist)}
			let(:album) {create(:album,artist: artist)}
			

			it 'should be valid for album with all attributes' do 
				expect(album.valid?).to eq(true)
			end

			it 'should belong to an artist' do 
				expect(album.artist).to eq(artist)
			end
            
            it 'is not valid for album without title' do 
            	album.title = nil
            	expect(album.valid?).to eq(false)
            end 

            it 'is not valid for album without language' do 
            	album.language = nil
            	expect(album.valid?).to eq(false)
            end

             it 'is not valid for album without description' do 
            	album.description = nil
            	expect(album.valid?).to eq(false)
            end
		end 
		describe "Associations" do 
			let(:artist) {create(:artist)}
			let(:album) {create(:album, artist: artist)}
            let(:user){build(:user)}
            let(:song){build(:song,artist: artist)}

			it 'belongs to an artist' do 
				expect(album.artist).to eq(artist)
			end
		end

		context "has and belongs to many " do 
			[:songs,:playlists].each do |sym|
				it sym.to_s.humanize do 
					association = Album.reflect_on_association(sym).macro
				    expect(association).to be(:has_and_belongs_to_many)
				end 
			end 
		end 

        it "has one image" do 
	    	association = Album.reflect_on_association(:image).macro 
	    	expect(association).to be(:has_one)
	    end 
	end 
end