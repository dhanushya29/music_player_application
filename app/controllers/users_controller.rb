class UsersController < ApplicationController
	before_action :authenticate_user!
	def index
		@users=User.all
		@albums=Album.all    
	end

	def new
		@user=User.new
	end

	def create
		@user=User.new
		if @user.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def show
		@user=User.find(params[:id])
		@songs=Song.all
		@albums=Album.all 
		#@images=@user.image.all 
	end

	private
	def user_params
		params.require(:user).permit(:username,:email,:phone,:password)
	end
end