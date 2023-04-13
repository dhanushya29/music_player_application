require 'rails_helper'

RSpec.describe User,type: :model do 
	describe 'Validation testing' do 

		context 'While creating user' do 
			let(:user1) {build :user}
			let(:user2) {build :user,email: "email"}
			let(:user3) {build :user,username: "anu"}
			let(:user4) {build :user,username: "anubgthuiopkmlgthfav"}
			let(:user5) {build :user,username: "ab sed"}
			let(:user6) {build :user,phone: -1}
			let(:user7) {build :user,phone: 12345}
			let(:user8) {build :user,phone: "string"}

			it 'should be valid user with all attributes' do 
				expect(user1.valid?).to eq(true)
			end 

			it 'should not be valid user,without valid email' do 
				expect(user2.valid?).to eq(false)
			end 

			it 'should not be valid user,without username' do 
				user1.username=nil
				expect(user2.valid?).to eq(false)
			end 

			it 'should not be valid user,without valid username(minimum 5 chars)' do 
            	expect(user3.valid?).to eq(false)
            end 

            it 'should not be valid user,without valid username(only 16 chars)' do 
            	expect(user4.valid?).to eq(false)
            end 
            
            it 'should not be valid user,without valid username(format)' do 
            	expect(user5.valid?).to eq(false)
            end

            it 'should not be valid user,without valid phone number(cannot be negative)' do 
            	expect(user6.valid?).to eq(false)
            end

            it 'should not be valid user,without valid phone number(minimum 10 digits)' do 
            	expect(user7.valid?).to eq(false)
            end

            it 'should not be valid user,without valid phone number(only numbers)' do 
            	expect(user8.valid?).to eq(false)
            end
		end 

		context "has many " do 
			[:playlists].each do |sym|
				it sym.to_s.humanize do 
					association = User.reflect_on_association(sym).macro
					expect(association).to be(:has_many)
				end 
			end 
		end

		it "has one image " do 
			association = User.reflect_on_association(:image).macro 
			expect(association).to be(:has_one)
		end
	end 
end