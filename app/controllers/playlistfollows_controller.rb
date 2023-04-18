class PlaylistFollowsController < ActionController
	def create
		@playlist_follow = PlaylistFollow.create(:user_id=>current_user.id,:playlist_id=>params[:playlist_id])
		@playlist = Playlist.find(params[:playlist_id])
		if @playlist_follow.save 
			redirect_to @playlist
		else
			flash[:alert] = "Something went wrong"
			redirect_to root_path
		end 
	end 
end