require 'rails_helper'

RSpec.describe Artist,type: :model do 
	describe 'Validation testing' do 
		context 'While creating artist' do 
			let(:artist1) {build :artist}
			let(:artist2) {build :artist,email: "artistemail"}
            let(:artist3) {build :artist,name:"Ana"}
            let(:artist4) {build :artist,name:"htygjuiopkmnbgtfd"}


			it 'should be valid artist with all attributes' do 
				expect(artist1.valid?).to eq(true)
			end 

			it 'should not be valid artist without name ' do 
				artist1.name=nil
				expect(artist2.valid?).to eq(false)
			end 
   
            it 'should not be valid artist without valid email' do 
            	expect(artist2.valid?).to eq(false)
            end

            it 'should not be valid artist without region' do 

            	artist1.region=nil
            	expect(artist2.valid?).to eq(false)
            end

            it 'should not be valid artist,without valid name(minimum 5 chars)' do 
            	expect(artist3.valid?).to eq(false)
            end 

            it 'should not be valid artist,without valid name(only 16 chars)' do 
            	expect(artist4.valid?).to eq(false)
            end 
		end 
	end 
    

    it "has one image" do 
    	association = Artist.reflect_on_association(:image).macro 
    	expect(association).to be(:has_one)
    end 

    context "has many " do 
    	[:albums,:songs].each do |sym|
    		it sym.to_s.humanize do 
    			association = Artist.reflect_on_association(sym).macro
    			expect(association).to be(:has_many)
    		end 
    	end 
    end 
end