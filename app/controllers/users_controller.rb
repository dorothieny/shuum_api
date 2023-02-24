class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :following, :followed, :liked, :created, :feed]

  def index
    @users = User.all
    filtering_params(params).each do |key, value|
      @users = @users.public_send("filter_by_#{key}", value) if value.present?
    end
    render json: @users
  end

  def show
    @user = User.find_by_id(params[:id])
    render json: @user
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: {message: 'User deleted'}
  end

  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    render json: {message: 'User is followed by you!'}
    # redirect_back(fallback_location: user_path(@user))
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
    render json: {message: 'User is unfollowed by you!'}
    # redirect_back(fallback_location: user_path(@user))
  end

  def following
    @user = User.find(params[:id])
    if @user
      @follow = @user.followed_users
      @following = @user.followees.all
      render json: @following
    end
  end


  def liked
    @user = User.find(params[:id])
    if @user
      @liked = @user.liked_soundcards
     @liked = @liked.map do |soundcard|
        soundcard.as_json.merge({:tags => soundcard.tags})
    end
      render json: @liked
    end

  end

  def created
    @user = User.find(params[:id])
    if @user
      @soundcards = Soundcard.where(user_id: @user.id).map do |soundcard|
        soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
    end
      
      render json: @soundcards
    end

  end


  def following
    @user = User.find(params[:id])
    if @user
      @follow = @user.followed_users
      @following = @user.followees.all
      render json: @following
    end
  end

  def followed
    @user = User.find(params[:id])
    if @user
      @following = @user.followers.all
      render json: @following
    end
  end

  def feed 
    @user = User.find(params[:id])
    if @user

      @following = @user.followees.all.map do |followee| 

        @soundcards = Soundcard.all.select {|soundcard| soundcard.user_id == followee.id && soundcard.created_at >= Date.today - 7 && soundcard.strikes.count <= 2}
        @soundcards = @soundcards.map do |soundcard|
          soundcard.as_json.merge({:likes => soundcard.likes, :tags => soundcard.tags})
      end
      
        followee.as_json.merge({:sounds => @soundcards.first(3), :count => @soundcards.count})

      end
      render json: @following
    end
  end

  def update_info
    @user = User.find(params[:id])

    if @user.update(user_params)
      render json: {message:'The user info successfully updated'}
    else
      render json: {message:'Failed'}
    end
  end

  def user_params
    params.require(:user).permit(:name, :avatar)
  end

  def filtering_params(params)
    params.slice(:starts_with)
  end

end
