class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]



  def index
    @events = Event.around_me.includes(:user,pet: [:colors,:breed,:weight])
  end

  def show
    @events = Event.all
  end
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end
  
  # # Never trust parameters from the scary internet, only allow the white list through.
  # def lost_dog_params
  #   params.permit(:description, :latitude, :longitude, :pet_id, :user_id)
  # end
end
