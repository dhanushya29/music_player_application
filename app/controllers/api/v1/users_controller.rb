class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user,only: [:show,:update,:destroy]
  before_action :doorkeeper_authorize!
  def set_user
    @user=User.find(params[:id])
    rescue
      render json: "User not found",status: :not_found
  end

  def index
    users=User.all 
    render json: {user:users}
  end

  def new
    user=User.new
    render json: {user: users}
  end

  def show
    # image=@user.image.all 
    # render json: {user:@user,image:image}
  end

  def update
    if @user.update(user_params)
      render json: {message:"User updated",user:@user}
    else
      render json: {message:"User not updated"}
    end 
  end

  def destroy
    @user.destroy
    render json:{message:"user deleted",user:@user}
  end

  def create
    user=User.new(user_params)
    if user.save
      render json:{user:user}
    else 
      render json:{message:"user not created"}
    end 
  end

  private
  def user_params
    params.permit(:username,:email,:phone,:password)
  end 
end
