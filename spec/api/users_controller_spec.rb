require 'rails_helper'

RSpec.describe "User",type: :request do 
	describe "GET #index" do 
		let(:token) { instance_double('Doorkeeper::AcessToken')}

		before do
			allow_any_instance_of(Api::V1::UsersController).to receive(:doorkeeper_authorize!).and_return(true)
		end 

		let(:user1){create :user,email:"user1@gmail.com",phone:9087654321}
		let(:user2){create :user,email:"user2@gmail.com",phone:8097654321}

		it 'returns a success response' do 
			get api_v1_users_path
			expect(response).to have_http_status(200)
		end 

		it "returns all users" do 
			get api_v1_users_path,headers:{"Authorization" => "my-token"}
			expect(JSON.parse(response.body)['user'].count).eql?(2)
		end 
	end 

	describe "GET #new" do 
		let(:token) {instance_double('Doorkeeper::AccessToken')}

		before do 
			allow_any_instance_of(Api::V1::UsersController).to receive(:doorkeeper_authorize!).and_return(true)
		end 

		let(:user3){User.new}

		before{get new_api_v1_user_path}

		it 'returns a success response' do 
			expect(response).to have_http_status(:ok)
		end 

		it 'returns a new user' do 
			expect(JSON.parse(response.body)).to include("user" => user3.as_json.stringify_keys)
		end 
	end


	describe "POST #create" do 
		let(:token){instance_double('Doorkeeper::AccessToken')}
        let(:user){create(:user)}
        let(:user_token){create(:doorkeeper_access_token,resource_owner_id: user.id)} 
        before do 
			allow_any_instance_of(Api::V1::ArtistsController).to receive(:doorkeeper_authorize!).and_return(true)
		end 
		context "with valid params" do 

			it "creates a new user" do 
				expect{
					post '/api/v1/users',params: {accesss_token:user_token,artist:{name:"dua",email:"dua@gmail.com",phone:8976543219,image_url:"https://i.scdn.co/image/ab6761610000e5ebd42a27db3286b58553da8858",password:"123456"}}
				}.to change(User,:count).by(1)
			end 
		end 

		context "with invalid params" do 

			it "does not create a new user" do 
				expect{
					post '/api/v1/users',params: {name: nil}
				}.to change(User,:count).by(0)
			end 

			it "renders the new template" do 
				post '/api/v1/users',params: {name:nil,email: "usr1@gmail.com"}
				expect(response).to have_http_status(401)
			end
		end 
    end


    describe "DELETE #destroy" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

    	before do 
    		allow_any_instance_of(Api::V1::UsersController).to receive(:doorkeeper_authorize!).and_return(true)
    	end

    	let!(:user) {create(:user)}
    	it "deletes the user" do 
    		expect {
    			delete "/api/v1/users/#{user.id}",params: {id:user.id}
    		}.to change(User,:count).by(-1)
    	end 

    	it 'returns a JSON response with message "user deleted" and the deleted user' do 
    		delete "/api/v1/users/#{user.id}"
    		expect(response).to have_http_status(:ok)
    		expect(JSON.parse(response.body)["user"]["id"]).to eq(user.id)
    	end 
    end

    describe "PATCH #update" do 
    	let(:token) {instance_double('Doorkeeper::AccessToken')}

    	before do 
    		allow_any_instance_of(Api::V1::UsersController).to receive(:doorkeeper_authorize!).and_return(true)
    	end 

    	let!(:user) {create(:user)}
    	it "updates the user" do 
    		patch "/api/v1/users/#{user.id}",params: {id:user.id,username:"Harish"}
    		expect(user.reload.username).to eq("Harish")
    	end 
    end
end