require 'rails_helper'

RSpec.describe Image,type: :model do 
	context "imageable" do 
		it "must exists" do 
			image=build(:image,imageable: nil)
			expect(image.save).to be_falsey
		end 
	end 
    
   describe 'Validation testing' do 
		let(:image){create(:image)}

		it 'is valid with valid attributes' do 
			expect(image).to be_valid 
		end 
	end 

	describe 'Association' do 
		let(:image) { build(:image)}

		it 'belongs to a user or seller or playlist or album' do 
			expect(image.imageable).to be_present
		end 
	end 

end 