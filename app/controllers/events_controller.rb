class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy, :chat]
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

    @current_user_id = current_user.id
    
  end

  def events_map
    @events = Event.where(:is_around_me => 1)
    render :show
  end

  def filter_events
    @filter_events = params[:filter_events]
    @current_user_id = current_user.id

    respond_to do |format|
      format.js {render :filter_events}
    end

  end

  # Get the chat for event 1
  # GET /events/1/chat
  def chat
    @chat = @event.chat
    @message = Message.new

    if @chat.nil?
      @chat = Chat.new(identifier: SecureRandom.hex)

      if !@chat.persisted?
        @chat.save
        @event.update(chat_id: @chat.id)
      end
    end

    respond_to do |format|
      format.html { render "event_chat" }
      # format.json { head :no_content }
    end
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
