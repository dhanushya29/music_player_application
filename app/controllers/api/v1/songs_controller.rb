class Api::V1::SongsController < Api::V1::ApiController
  before_action :set_song, only: %i[ show edit update destroy ]
  before_action :artist_or_user,only: %i[update destroy edit]
  before_action :doorkeeper_authorize!


  def set_song 
    @song=Song.find(params[:id])
    rescue
      render json: "Song not found",status: :not_found
  end 
  
  def song_params
      params.require(:song).permit(:title, :album_id, :duration, :lyrics)
  end

  def artist_or_user 
      if current_user.present?
        render json: "User cannot create/ modify / delete albums"
      end 
    end

  def index 
     if current_user.present?
       songs=Song.all
     else
      if current_artist.present?
        artists=Artist.all
        #album = Album.find params[:album_id]
        songs = current_artist.songs
      end
    end
    render json: {Songs: songs}
  end

  def show
    render json: {message:"Showing song",song:@song}
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
    if current_artist.is_a? Artist
      song=current_artist.songs.create(song_params)
      song.albums << Album.find(params[:album_id])
      if song.save
        render json: {song:song}
      else
        render json: {message:"Song not created"}
      end 
    else
      render json:{message:"unauthorized"},status: :unauthorized
    end
  end
end 