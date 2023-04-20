class Api::V1::SongsController < Api::V1::ApiController
  before_action :set_song, only: %i[ show edit update destroy ]
  # before_action :artist_or_user,only: %i[update destroy edit]
  before_action :doorkeeper_authorize!


  def set_song 
    @song=Song.find(params[:id])
    rescue
      render json: "Song not found",status: :not_found
  end 
  
  def song_params
      params.require(:song).permit(:title, :album_id, :duration, :lyrics)
  end

  def index
     if current_artist.is_a? Artist
        songs = current_artist.songs
      else
        songs = Song.all 
      end 
        render json: {Songs:songs}
  end

  def show
    render json: {message:"Showing song",song:@song}
  end

  def update
    if current_artist.is_a? Artist
      if @song.artist_id == current_artist.id
        if @song.update(song_params)
          render json: {message:"Song #{@song.id} is updated successfully"}
        else
          render json: {message:"Song not updated"}
        end
      else
        render json: {message:"unauthorized"},status: :unauthorized
      end
    else
      render json: {error:"You are not allowed to updatee"},status: 403
    end
  end


  def destroy
    if current_artist.is_a? Artist
        if @song.destroy
          render json: {message: "Song #{@song.id} is deleted successfully"},status: 204
        else
          render json: {message:"Song not deleted"}
        end
    else
      render json: {message:"You are not allowed to delete"},status: 403
    end
  end

  def create
    if current_artist.is_a? Artist
      song=current_artist.songs.create(song_params)
      album=Album.find(params[:album_id])
      if album.artist_id == current_artist.id
        song.albums << Album.find(params[:album_id])
        if song.save
          render json: {message:"Song #{song.id} is created successfully"},status: 201
        else
          render json: {message:"Song not created"}
        end 
      else
         render json:{message:"unauthorized"},status: :unauthorized
      end
    else
      render json: {message:"You are not allowed to create"},status: 403
    end
  end
end 