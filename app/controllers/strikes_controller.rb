class StrikesController < ApplicationController
    before_action :find_soundcard
    before_action :find_strike, only: [:destroy]

    def index 
        strikes = Strike.all
        strikes = Strike.where(nil)
        render json: {status: "SUCCESS", message: "All strikes ready", data: strikes}, status: :ok
    end
    
   def create
    if already_striked?
        # @strike.destroy
        render json: {message: "You can't strike more than once"} 
      else
        @soundcard.strikes.create(user_id: current_user.id)
        render json: {message: 'You striked this post'}
    end
   end

   def destroy
    if !(already_striked?)
        render json: {message: "You can't delete strike more than once"} 
    else
        if current_user.isadmin?
             @soundcard.strikes.destroy_all
        else 
        render json: {message: "You can't delete strike as you are not an admin"} 
     end
    end
    render json: {message: "Delete your strike"} 
  end

   private

   def find_strike
    @strike = @soundcard.strikes.find(params[:id])
 end

   def already_striked?
    Strike.where(user_id: current_user.id, soundcard_id:
    params[:soundcard_id]).exists?
  end

   def find_soundcard
    @soundcard = Soundcard.find(params[:soundcard_id])
   end
   

 end
