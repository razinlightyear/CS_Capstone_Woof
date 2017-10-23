class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  #before_action :get_all_events, only: [:show], if: :format_json
  #before_action :get_all_events, only: [:events_map]
  before_action :get_all_events, only: [:show, :events_map]
  
  def index
    @events = Event.around_me.includes(:user,pet: [:colors,:breed,:weight])
  end

  def show
    if request.format.json?
      @events = Event.where(:is_around_me => 1)
    end
  end

  def events_map
    @events = Event.where(:is_around_me => 1)
    render :show
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def get_all_events
  end

  def format_json?
    true
  end
  
  # # Never trust parameters from the scary internet, only allow the white list through.
  # def lost_dog_params
  #   params.permit(:description, :latitude, :longitude, :pet_id, :user_id)
  # end
end
