class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[ show edit update destroy ]

  def index
    @playlists = Playlist.all
    @users=User.all
  end

  
  def show
    @user =current_user
    @song=Song.all
    @album=Album.all 
    @image=@playlist.image
  end

  def new
    @playlist = Playlist.new
    @user=params[:user_id]
  end

   def insert
        @user=current_user
        @song=Song.find(params[:song_id])
        @playlist=Playlist.find(params[:playlist_id])
        if @playlist.present?
            if @playlist.songs.include?(@song)
                flash[:notice] = "Already added"
            else
                @playlist.songs << @song
            end
            flash[:notice] = "#{@song.title} added to playlist"
        else
            @playlist=@user.playlists.create(user_id: params[:user_id])
            @user.playlist.songs << @song
        end
        redirect_to playlists_path
      end

      def insertalbum
        @user=User.find(params[:user_id])
        @album=Album.find(params[:album_id])
        @playlist=Playlist.find(params[:playlist_id])
        if @playlist.present?
            if @playlist.albums.include?(@album)
                flash[:alert] = "Already added"
            else
                @playlist.albums << @album
                flash[:notice] = "#{@album.title} added to playlist"
            end
            
        else
            @playlist=@user.playlists.create(user_id: params[:user_id])
            @user.playlist.albums << @album
        end
        redirect_to playlists_path
    end

  def edit
  end

  
  def create
    @playlist = Playlist.new(playlist_params)
    @user=current_user
    @playlist.user = @user 
      if @playlist.save
         image =  @playlist.build_image
         image.image_url = @playlist.image_url
         image.save
        redirect_to playlists_path
      else 
        render 'new'
    end
  end

  # PATCH/PUT /playlists/1 or /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully updated." }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    if(params[:song_id])
      @playlist.songs.delete( Song.find params[:song_id] )
    elsif (params[:album_id])
      @playlist.albums.delete(Album.find params[:album_id])
    else
      @playlist.destroy
  end
    redirect_to playlists_path
  end

  
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:username,:phone,:email)
    end
    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:user_id, :title, :description,:image_url)
    end
end
