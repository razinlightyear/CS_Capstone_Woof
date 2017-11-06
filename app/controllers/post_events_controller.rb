class PostEventsController < ApplicationController

    def show
    end

    def new
        @post_event = PostEvent.new
        @user = current_user
    end

    def create
        @post_event = PostEvent.new(post_event_params)
        @post_event.is_around_me = true

        respond_to do |format|
            if @post_event.save
                format.js 
                format.html { redirect_to event_path(current_user), notice: 'AroundMe event has been created' }
                format.json
            else
                format.html { render :new }
                format.json { render json: @post_event.errors, status: :unprocessable_entity }
            end
        end
    end


    private

    def post_event_params
        params.require(:post_event).permit(:user_id ,:descripion, :latitude, :longitude, :address, :private, :date_time)
    end

end