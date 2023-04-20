require 'rails_helper'

RSpec.describe Song,type: :model do 
	describe 'Validation testing' do 

		context 'While creating playlist' do
			let(:user) {create(:user)}
            let(:artist) {create(:artist)}
            let(:song) {create(:song,artist: artist)}

			it 'should be valid song with all attributes' do 
				expect(song.valid?).to eq(true)
			end

			it 'should belong to an artist' do 
				expect(song.artist).to eq(artist)
			end

			it 'is not valid for song without title' do 
			    song.title=nil
			    expect(song.valid?).to eq(false)
			end

			it 'is not valid for song without duration' do 
            	song.duration = nil
            	expect(song.valid?).to eq(false)
            end

            it 'is not valid for song without lyrics' do 
            	song.lyrics = nil
            	expect(song.valid?).to eq(false)
            end
		end 

	end
		it 'belongs to an artist' do 
			association = Song.reflect_on_association(:artist).macro 
	    	expect(association).to be(:belongs_to)
		end

		context "has and belongs to many " do 
			[:albums,:playlists].each do |sym|
				it sym.to_s.humanize do 
					association = Song.reflect_on_association(sym).macro
				    expect(association).to be(:has_and_belongs_to_many)
				end 
			end 
		end 

		describe "Callback testing" do 
    	let(:artist){create(:artist)}
		let(:song) {create(:song,artist: artist)}

		context "normalize title" do 
			it "does the capitalisation" do 
				song.validate!
				expect(song.reload.title).to eq "Aioaio"
			end
		end
	end
end 
