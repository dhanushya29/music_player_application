class Api::V1::SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]
  before_action :set_artist ,only: [:create]
  skip_before_action :verify_authenticity_token
  def set_song 
    @song=Song.find(params[:id])
    rescue
      render json: "Song not found",status: :not_found
  end 
  
  def song_params
      params.require(:song).permit(:title, :album_id, :duration, :lyrics)
  end

  def set_artist
     @artist=Artist.find(params[:artist_id])
     rescue
      render json: "Artist not found",status: :not_found
  end 
  
  def set_user
     @user=User.find(params[:user_id])
   rescue
    render json: "User not found",status: :not_found
  end

  def index
    songs=Song.all 
     if params.has_key?(:user_id)
       songs=Song.all
    else
      if params.has_key?(:artist_id)
        artists=Artist.all
        album = Album.find params[:album_id]
        songs = @album.songs
      end
    end
    render json: {Songs: songs}
  end

  def show
  end

  def update
    if @song.update(song_params)
      render json: {song:@song}
    else
      render json: {message:"Song not updated"}
    end
  end


  def destroy
    @song.destroy
    render json: {song:@song}
  end

  def create
    if params.has_key?(:artist_id)&params.has_key?(:album_id)
      song=@artist.songs.create(song_params)
      song.albums << Album.find(params[:album_id])
      if song.save
        render json: {song:song}
      else
        render json: {message:"Song not created"}
      end 
    else
      playlist=@user.playlist
      song=Song.find(params[:song_id])
      render json: {song:song}
    end 
  end
end 