class LostDogsController < ApplicationController

    def create
        ld = LostDog.create!(description: params[:description], latitude: params[:latitude], longitude: params[:longitude], pet_id: params[:pet_id], user_id: params[:user_id], is_around_me: true)

        respond_to do |format|
        format.js{ render 'events/lost_dog_event_creation', :locals => {:latitude => params[:latitude] , :longitude => params[:longitude], :description => params[:description]}}

        format.json{ render plain:  "You created a lost dog for pet_id: #{params[:pet_id]} by user_id #{params[:user_id]}"}
        end
    end

end