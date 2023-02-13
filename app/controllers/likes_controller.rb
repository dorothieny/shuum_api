class LikesController < ApplicationController
    before_action :find_soundcard
    before_action :find_like, only: [:destroy]

    def index 
        likes = Like.all
        likes = Like.where(nil)
        render json: {status: "SUCCESS", message: "All likes ready", data: likes}, status: :ok
    end
    
   def create
    if already_liked?
        @like.destroy
        render json: {message: "You can't like more than once"} 
      else
        @soundcard.likes.create(user_id: current_user.id)
        render json: {message: 'You have amazing taste!'}
    end
   end

   def destroy
    if !(already_liked?)
        render json: {message: "You can't unlike more than once"} 
    else
      @like.destroy
    end
    render json: {message: "Delete your like"} 
  end

   private

   def find_like
    @like = @soundcard.likes.find(params[:id])
 end

   def already_liked?
    Like.where(user_id: current_user.id, soundcard_id:
    params[:soundcard_id]).exists?
  end

   def find_soundcard
    @soundcard = Soundcard.find(params[:soundcard_id])
   end
   

 end