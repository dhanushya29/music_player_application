class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[ show edit update destroy ]

  # GET /playlists or /playlists.json
  def index
    @playlists = Playlist.all
  end

  # GET /playlists/1 or /playlists/1.json
  def show
    # @user =User.find(params[:id])
    # if @user.playlist.present?
    #   @playlist=@user.playlist
    #   @playlist.save
    # end
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
    # @user=User.find(params[:user_id])
  end

   def insert
        @user=User.find(params[:user_id])
        @song=Song.find(params[:song_id])
        if @user.playlist.present?
            if @user.playlist.songs.include?(@song)
                flash[:notice] = "Already added"
            else
                @user.playlist.songs << @song
            end
            
        else
            @playlist=@user.create_playlist(user_id: params[:user_id])
            @user.playlist.songs << @song
        end
        flash[:notice] = "#{@song.name} added to playlist"
      
        redirect_to playlists_path
    end

  # GET /playlists/1/edit
  def edit
  end

  # POST /playlists or /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.user = User.first 
    respond_to do |format|
      if @playlist.save
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully created." }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
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
    @playlist.destroy
    # @user = User.find(params[:id])
    # @playlist=Playlist.find(params[:playlist_id])
    # @song=@playlist.songs.find(params[:song_id])
    # @playlist.songs.delete(@song)
    redirect_to playlist_path(current_user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:username,:phone,:email)
    end
    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:user_id, :title, :description)
    end
end
