class PostEventsController < ApplicationController
    before_action :set_post_event, only: [:show, :edit, :update, :destroy]
    before_action :can_edit_delete, only: [:edit, :update, :destroy] 

    def show
        @chat = @post_event.chat
        @message = Message.new

        if @chat.nil?
            @chat = Chat.new(identifier: SecureRandom.hex)

            if !@chat.persisted?
                @chat.save
                @post_event.update(chat_id: @chat.id)
            end
        end
        
        @pending_invites = EventInvite.where(accepted_at: nil, declined_at: nil, event: @post_event).eager_load(:invitee)
    end

    def new
        if params[:post_event].nil?
            @post_event = PostEvent.new
        else    
            @post_event = PostEvent.new(post_event_params)
        end
        
        @user = current_user
    end

    def edit
        @user = current_user
        @invites = EventInvite.where(accepted_at: nil, declined_at: nil, event: @post_event)
    end

    def create
        massage_date unless request.format.json?
        @post_event = PostEvent.new(post_event_params)
        @post_event.is_around_me = true
        
        respond_to do |format|
            if @post_event.save
                format.js
                format.html { redirect_to event_path(current_user), notice: 'AroundMe event has been created' }
                format.json # have to work on this part
            else
                format.html { render :new }
                format.json { render json: @post_event.errors, status: :unprocessable_entity }
            end
        end
    end

    def update_lost_address
        @post_event = params[:post_event]
        @event = Event.find_by(id: @post_event['event_id'])
        #@event.update(address: @lost_dog['address'])
        @event.update(latitude: @post_event['latitude'].to_f, longitude: @post_event['longitude'].to_f, address: @post_event['address']);
    end

    def update
        massage_date unless request.format.json?
        respond_to do |format|
            if @post_event.address != params[:post_event][:address]
                if @post_event.update(post_event_params)
                    format.js
                    # for doing the JSON reply
                    format.json { render :show, status: :ok }
                else
                    format.html { render :edit }
                    format.json { render json: @post_event.errors, status: :unprocessable_entity }     
                end
            else
                if @post_event.update(post_event_params)
                    format.js
                    #format.html { redirect_to event_path(current_user), notice: 'Around Me event has been updated' }
                    # for doing the JSON reply
                    format.json { render :show, status: :ok }
                else
                    format.html { render :edit }
                    format.json { render json: @post_event.errors, status: :unprocessable_entity }     
                end
            end
        end


    end

    # DELETE /lost_dogs/1
    # DELETE /lost_dogs/1.json
    def destroy
        @post_event.destroy
        
        respond_to do |format|
            #format.html { redirect_to event_path(current_user), notice: 'Post an Event was successfully destroyed.' }
            format.js
            format.json { head :no_content }
        end
    end

    private

    def post_event_params
        params.require(:post_event).permit(:user_id ,:description, :latitude, :longitude, :address, :private, :date_time)
    end

    def set_post_event
        @post_event = Event.includes(:joined_users).find(params[:id])
    end

    def can_edit_delete
        if @post_event.user.id != current_user.id
            respond_to do |format|
                format.json {render json: "Not authorized since you have not posted the event"}
            end            
        end 
    end

    def massage_date
      if params[:post_event][:date_time] && !params[:post_event][:date_time].empty?
        params[:post_event][:date_time] = DateTime.strptime(params[:post_event][:date_time],"%m/%d/%Y %l:%M %p")
      end
    end
end