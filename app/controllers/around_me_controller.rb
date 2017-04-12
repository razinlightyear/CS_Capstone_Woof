class AroundMeController < ApplicationController
  before_action :set_around_me, only: [:edit, :update, :destroy]
  def index
    @around_me_events = AroundMe.all
  end

  def show
    @user = User.find(params[:user_id])
    @around_me_events = Event.where(pet_event_type: "AroundMe", user_id: params[:user_id]).includes(:pet_event)
  end
  
  def create_lost_dog
    ld = LostDog.create(description: params[:description])
    am = AroundMe.create(around_me_event: ld, latitude: params[:latitude], longitude: params[:longitude])
    e = Event.create(pet_event: am, pet_id: params[:pet_id], user_id: params[:user_id])
    render plain: "You created a lost dog for pet_id: #{params[:pet_id]} by user_id #{params[:user_id]}"
  end
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_around_me
    @around_me = AroundMe.find(params[:id])
  end
end
