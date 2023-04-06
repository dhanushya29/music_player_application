class Api::V1::PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[ show edit update destroy ]
  before_action :set_user ,only: [:create]
  skip_before_action :verify_authenticity_token
  def set_user
    @user=User.find(params[:user_id])
    rescue
      render json: "User not found",status: :not_found
  end

  def set_playlist
    @playlist=Playlist.find(params[:id])
    rescue
      render json: "Playlist not found",status: :not_found
  end 
  
  def index
    playlists = Playlist.all
    render json: {Playlists:playlists},status: :ok
  end

  
  def show
   render json: {message:"Showing playlist",playlist:@playlist,songs:@playlist.songs}
  end

  def new
    playlist = Playlist.new
    render json: {playlist: playlist}
  end

   def insert
      if(params.has_key?(:user_id)&params.has_key?(:song_id)&params.has_key?(:playlist_id))
        @user=User.find(params[:user_id])
        song=Song.find(params[:song_id])
        playlist=Playlist.find(params[:playlist_id])
        if playlist.present?
            if playlist.songs.include?(song)
                render json: {message:"Already added"}
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
end

  def edit
  end


  def create
    playlist=@user.playlists.create(title: params[:title],description: params[:description])
    if playlist.save
      render json: {playlist: playlist}
    else
      render json: {message: "Playlist not created"}
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
     if(params.has_key?(:song_id)&params.has_key?(:user_id)&params.has_key?(:playlist_id))
       @playlist.songs.destroy( Song.find params[:song_id] )
     else
       @playlist.destroy
     end
    render json: {playlist: @playlist}
  end
   
  private
  def playlist_params
    params.permit(:title,:description)
  end   
end
