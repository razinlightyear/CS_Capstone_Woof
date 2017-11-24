class LostDogsController < ApplicationController
    before_action :set_lost_dog, only: [:show, :edit, :update, :destroy]
    before_action :can_edit_delete, only: [:edit, :update, :destroy]

    def show
    end

    # for creating new lost dog empty form
    # have to check this functionality
    def new
        @lost_dog = LostDog.new
        @user = current_user
        # have to deal with the case when user doesn;t have any pets.
    end

    def edit
        @user = current_user
    end

    def get_pets
        @pets = Pet.where(group_id: params[:group_id])
        @pets_set = []
        @pets.each do |pet|
            @pets_set << [pet.name, pet.id]
        end

        render :partial => 'pets', :object => @pets_set
    end

    # for creating lost dog when form is submitted
    def create
        @lost_dog = LostDog.new(lost_dog_params)
        @lost_dog.is_around_me = true;

        respond_to do |format|
            if @lost_dog.save
                format.js
                format.html { redirect_to event_path(current_user), notice: 'Lost Dog has been created' }
                # Andrew: Don't know about this
                format.json { render :show, status: :created, location: @breed }
            else
                format.html { render :new }
                format.json { render json: @lost_dog.errors, status: :unprocessable_entity }
            end
        end
        
        #respond_to do |format|
        #format.js{ render 'events/lost_dog_event_creation', :locals => {:latitude => params[:latitude] , #:longitude => params[:longitude], :description => params[:description]}}

        #format.json{ render plain:  "You created a lost dog for pet_id: #{params[:pet_id]} by user_id #{params[:user_id]}"}
        #end
    end

    def update_lost_address
        @lost_dog = params[:lost_dog]
        @event = Event.find_by(id: @lost_dog['event_id'])
        @event.update(latitude: @lost_dog['latitude'].to_f, longitude: @lost_dog['longitude'].to_f, address: @lost_dog['address']);
    end

    def update

        respond_to do |format|
            if @lost_dog.address != params[:lost_dog][:address]
                if @lost_dog.update(lost_dog_params)
                    format.js
                    # for doing the JSON reply
                    format.json { render :show, status: :ok }
                else
                    format.html { render :edit }
                    format.json { render json: lost_dog.errors, status: :unprocessable_entity }
                end
            else
                if @lost_dog.update(lost_dog_params)
                    #format.html { redirect_to event_path(current_user), notice: 'Lost Dog event has been updated' }
                    format.js
                    # for doing the JSON reply
                    format.json { render :show, status: :ok }
                else
                    format.html { render :edit }
                    format.json { render json: lost_dog.errors, status: :unprocessable_entity }     
                end
            end
        end


    end

    # DELETE /lost_dogs/1
    # DELETE /lost_dogs/1.json
    def destroy
        @lost_dog.destroy
        
        respond_to do |format|
            format.js
            #format.html { redirect_to event_path(current_user), notice: 'Lost Dog Event was successfully destroyed.' }
            format.json { head :no_content }
        end
    end  

    private

    def lost_dog_params
        # adding address field to the params list
        params.require(:lost_dog).permit(:user_id, :pet_id, :description, :latitude, :longitude, :address)
    end

    def set_lost_dog
        @lost_dog = Event.find(params[:id])
    end

    def can_edit_delete
        if @lost_dog.user.id != current_user.id
            respond_to do |format|
                format.json {render json: "Not authorized since you have not posted the event"}
            end
        end
    end

end