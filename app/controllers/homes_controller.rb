class HomesController < ApplicationController
	def index
		@artists=Artist.all 
	end 
end
