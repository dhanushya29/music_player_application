require 'rails_helper'

RSpec.describe Artist,type: :model do 
	describe 'Validation testing' do 
		context 'While creating artist' do 
			let(:artist1) {build :artist}
			# let(:artist2) {build :artist}


			it 'should be valid artist with all attributes' do 
				expect(artist1.valid?).to eq(true)
			end 
		end 
	end 
end