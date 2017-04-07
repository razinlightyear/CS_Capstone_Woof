class AroundMeController < ApplicationController
  before_action :set_around_me, only: [:edit, :update, :destroy]
  def index
    @around_me_events = AroundMe.all
  end

  def show
    @user = User.find(params[:user_id])
    @around_me_events = Event.where(pet_event_type: "AroundMe", user_id: params[:user_id]).includes(:pet_event)
  end
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_around_me
    @around_me = AroundMe.find(params[:id])
  end
end
