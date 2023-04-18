class HomesController < ApplicationController
	def index
		if params[:q].present?
			@albums=Album.where("name LIKE?","%#{params[:q]}%")
		else
			@albums=Album.all 
		end 
	end 
end
