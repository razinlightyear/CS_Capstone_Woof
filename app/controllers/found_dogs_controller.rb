class FoundDogsController < ApplicationController
    before_action :set_found_dog, only: [:show, :edit, :update, :destroy]
    before_action :can_edit_delete, only: [:edit, :update, :destroy]

    def show
    end
    
    # for creating new found dog empty form
    # have to check this functionality
    def new
        @found_dog = FoundDog.new
        @user = current_user
    end

    def edit
        @user = current_user
    end
    
    def create
        @found_dog = FoundDog.new(found_dog_params)
        @found_dog.is_around_me = true;
        
        respond_to do |format|
            if @found_dog.save
                format.js
                format.html { redirect_to event_path(current_user), notice: 'Found Dog has been created' }
            else
                format.html { render :new }
                format.json { render json: @found_dog.errors, status: :unprocessable_entity }          
            end
        end
    end

    def update_lost_address
        # update the address here.
        @found_dog = params[:found_dog]
        @event = Event.find_by(id: @found_dog['event_id'])
        #@event.update(address: @lost_dog['address'])
        @event.update(latitude: @found_dog['latitude'].to_f, longitude: @found_dog['longitude'].to_f, address: @found_dog['address']);
    end

    def update

        respond_to do |format|
            if @found_dog.address != params[:found_dog][:address]
                if @found_dog.update(found_dog_params)
                    format.js
                    # for doing the JSON reply
                    format.json { render :show, status: :ok }
                else
                    format.html { render :edit }
                    format.json { render json: found_dog.errors, status: :unprocessable_entity }     
                end
            else
                if @found_dog.update(found_dog_params)
                    format.html { redirect_to event_path(current_user), notice: 'Found Dog event has been updated' }
                    # for doing the JSON reply
                    format.json { render :show, status: :ok }
                else
                    format.html { render :edit }
                    format.json { render json: found_dog.errors, status: :unprocessable_entity }     
                end
            end
        end

        
    end

    # DELETE /found_dogs/1
    # DELETE /found_dogs/1.json
    def destroy
        @found_dog.destroy
        respond_to do |format|
            format.html { redirect_to event_path(current_user), notice: 'Found Dog Event was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    def found_dog_params
        params.require(:found_dog).permit(:user_id, :longitude, :latitude, :description, :breed_id, :weight_id, :address)
    end

    def set_found_dog
        @found_dog = Event.find(params[:id])
    end

    def can_edit_delete
        if @found_dog.user.id != current_user.id
            respond_to do |format|
                format.json {render json: "Not authorized since you have not posted the event"}
            end
        end
    end
end