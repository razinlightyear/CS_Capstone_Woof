class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  def index
    @events = Event.around_me.includes(:user,pet: [:colors,:breed,:weight])
  end

  def show
    @user = User.find(params[:user_id]) # The user that is "logged in"
    @pets = Pet.where(group: @user.groups).includes(:breed,:weight,:colors) # The "logged in" user's pets (so they can create a lost dog event)
    # If you find yourself needing to eager load on a specfic polymorphic associations, try this gem 'activerecord_lax_includes'
    @around_me_events = Event.where(is_around_me: true).includes(:user,pet: [:colors,:breed,:weight])

    @around_me_locations = Array.new();
    @descriptions = Array.new();

    @around_me_events.each do |around_me|
      @around_me_locations.push(around_me)
      @descriptions.push(around_me.description)
    end
    gon.around_me_events = @around_me_locations
    gon.event_types = @around_me_locations.map {|e| e.model_name.human }
    gon.descriptions = @descriptions

    return @around_me_events
  end
  
  def create_lost_dog
    ld = LostDog.create!(description: params[:description], latitude: params[:latitude], longitude: params[:longitude], pet_id: params[:pet_id], user_id: params[:user_id], is_around_me: true)

    respond_to do |format|
      format.js{ render 'events/lost_dog_event_creation', :locals => {:latitude => params[:latitude] , :longitude => params[:longitude], :description => params[:description]}}

      format.json{ render plain:  "You created a lost dog for pet_id: #{params[:pet_id]} by user_id #{params[:user_id]}"}
    end
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
