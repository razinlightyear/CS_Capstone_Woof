class AroundMeController < ApplicationController
  before_action :set_around_me, only: [:edit, :update, :destroy]
  def index
    @around_me_events = Event.where(pet_event_type: "AroundMe").includes(:user,pet: [:colors,:breed,:weight],pet_event: :around_me_event)
  end

  def show
    @user = User.find(params[:user_id]) # The user that is "logged in"
    @pets = Pet.where(group: @user.groups).includes(:breed,:weight,:colors) # The "logged in" user's pets (so they can create a lost dog event)
    # If you find yourself needing to eager load on a specfic polymorphic associations, try this gem 'activerecord_lax_includes'
    @around_me_events = Event.where(pet_event_type: "AroundMe").includes(:user,pet: [:colors,:breed,:weight],pet_event: :around_me_event)


    @around_me_locations = Array.new();
    @descriptions = Array.new();

    @around_me_events.each do |around_me|
      @around_me_locations.push(around_me.pet_event)
      @descriptions.push(around_me.pet_event.around_me_event.description)
    end

    gon.around_me_events = @around_me_locations
    gon.descriptions = @descriptions

    return @around_me_events
  end
  
  def create_lost_dog
    ld = LostDog.create(description: params[:description])
    am = AroundMe.create(around_me_event: ld, latitude: params[:latitude], longitude: params[:longitude])
    e = Event.create(pet_event: am, pet_id: params[:pet_id], user_id: params[:user_id])

    respond_to do |format|
      format.js{ render 'around_me/lost_dog_event_creation', :locals => {:latitude => params[:latitude] , :longitude => params[:longitude], :description => params[:description]}}
      
      format.json{ render plain:  "You created a lost dog for pet_id: #{params[:pet_id]} by user_id #{params[:user_id]}"}
    end
  end
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_around_me
    @around_me = AroundMe.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def lost_dog_params
    params.permit(:description, :latitude, :longitude, :pet_id, :user_id)
  end
end
