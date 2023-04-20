class Api::V1::PlaylistsController < Api::V1::ApiController
  before_action :set_playlist, only: %i[ show edit update destroy ]
  # before_action :artist_or_user ,only: %i[ edit update destroy show insert]
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
    if @playlist.user_id == current_user.id 
       render json: {message:"Showing playlist",playlist:@playlist,songs:@playlist.songs}
    else
      render json: {message:"You are not allowed to see"},status: 403
    end
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
          end
      else
        render json:{message:"unauthorized"},status: :unauthorized
      end
  end

  def edit
  end


  def create
    if current_user.is_a? User
        @playlist=Playlist.new(playlist_params)
        @playlist.user_id=current_user.id
        if @playlist.save
          render json: {message: "Playlist #{@playlist.id} is created successfully"},status: 201
        else
          render json: {message: "Playlist not created"}
        end
    else
      render json: {message:"You are not allowed to create"},status: 403
    end
  end

 
  
  def update
     if current_user.is_a? User
      if @playlist.user_id == current_user.id
        if @playlist.update(playlist_params)
           render json: {message: "Playlist #{playlist.id} is updated successfully"}
        else 
          render json: {message:"Playlist not updated"}
        end
      else
        render json: {message: "unauthorized"},status: :unauthorized
      end
    else
     render json: {error:"You are not allowed to update"},status: 403
    end
  end

 
  def destroy
    if current_user.is_a? User
      if @playlist.user_id == current_user.id
         if(params.has_key?(:song_id))
           @playlist.songs.delete(Song.find params[:song_id] )
         elsif(params.has_key?(:album_id))
           @playlist.albums.delete(Album.find params[:album_id] )
         else
           @playlist.destroy
          render json: {message:"Playlist is deleted"},status: 204
         end
         
      else
        render json: {error:"You are not allowed to delete"},status: 403
      end
    else
        render json:{message:"unauthorized"},status: :unauthorized
    end
  end
   
  private
  def playlist_params
    params.permit(:title,:description,:user_id,:song_id,:playlist_id)
  end   
end
