class Api::V1::PlaylistsController < Api::V1::ApiController
  before_action :set_playlist, only: %i[ show edit update destroy ]
  before_action :artist_or_user ,only: %i[ edit update destroy show insert]
  before_action :doorkeeper_authorize!

  def artist_or_user 
      if current_artist.present?
        render json: "Artist cannot create/ modify / view / delete playlists"
      end 
    end 

  def set_playlist
    @playlist=Playlist.find(params[:id])
    rescue
      render json: "Playlist not found",status: :not_found
  end 
  
  def index
    if current_user.is_a? User
    playlists = current_user.playlists.all
    render json: {Playlists:playlists},status: :ok
  else
    render json:{message:"unauthorized"},status: :unauthorized
  end
  end

  
  def show
   render json: {message:"Showing playlist",playlist:@playlist,songs:@playlist.songs}
  end

  def new
    playlist = Playlist.new
    render json: {playlist: playlist}
  end

   def insert
    if current_user.is_a? User
      if(params.has_key?(:song_id)&params.has_key?(:playlist_id))
        @user=current_user
        song=Song.find(params[:song_id])
        playlist=Playlist.find(params[:playlist_id])
        if playlist.present?
            if playlist.songs.include?(song)
                render json: {message:"Already added"},status: :ok
            else
                playlist.songs << song
                render json: {message:"Song added"}
            end
        else
            playlist=@user.playlists.create(user_id: params[:user_id])
            @user.playlist.songs << song
            render json: {message:"Playlist is created and song is added to playlist",playlist:playlist,song:song.as_json}
        end
        #render json:{message:"Enter params correctly"}
    end
  else
    render json:{message:"unauthorized"},status: :unauthorized
  end
end

  def edit
  end


  def create
    if current_user.is_a? User
        playlist=current_user.playlists.create(title: params[:playlist][:title],description: params[:playlist][:description])
        if playlist.save
          render json: {playlist: playlist}
        else
          render json: {message: "Playlist not created"}
        end
    else
      render json: {message:"unauthorized"},status: :unauthorized
    end
  end

  
  def update
      if @playlist.update(playlist_params)
         render json: {playlist: @playlist}
      else 
        render json: {message:"Playlist not updated"}
      end
  end

 
  def destroy
     if(params.has_key?(:song_id))
       @playlist.songs.delete(Song.find params[:song_id] )
     elsif(params.has_key?(:album_id))
       @playlist.albums.delete(Album.find params[:album_id] )
     else
       @playlist.destroy
     end
    render json: {message:"Deleted" , playlist: @playlist}
  end
   
  private
  def playlist_params
    params.permit(:title,:description,:user_id,:song_id,:playlist_id)
  end   
end
