class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy, :chat, :contact_owner_modal_body, :join, :disjoin, :view_message_from_user_modal_body, :view_messages_modal_body]
  #before_action :get_all_events, only: [:show], if: :format_json
  #before_action :get_all_events, only: [:events_map]
  before_action :get_all_events, only: [:show, :events_map]
  
  def index
    @events = Event.around_me.includes(:user,pet: [:colors,:breed,:weight])
  end

  def show
    if request.format.json?
      @events = Event.where(:is_around_me => true)
                     .where.not(id: PostEvent.select(:id)  # The events that aren't private
                                             .joins(:delegate)
                                             .where('post_event_delegates.private' => true)
                                             .where.not(user: current_user))
                     .where.not(id: LostDog.select(:id)  # Lost dogs that haven't been returned
                                    .joins(:delegate)
                                    .where('lost_dog_delegates.returned' => true))
                     .where.not(id: FoundDog.select(:id)  # Found dogs that haven't been returned
                                    .joins(:delegate)
                                    .where('found_dog_delegates.returned' => true))
                     .or(                    # The current user already belongs to the private event
                         Event.where(id: PostEvent.select(:id)
                                                  .where(:is_around_me => true)
                                                  .joins(:joined_users, :delegate)
                                                  .where('post_event_delegates.private' => true, 
                                                         'events_users.user_id' => current_user.id))
                         )
    end

    @current_user_id = current_user.id
    
  end

  def events_map
    @events = Event.where(:is_around_me => true)
                   .where.not(id: PostEvent.select(:id)  # The events that aren't private
                                           .joins(:delegate)
                                           .where('post_event_delegates.private' => true)
                                           .where.not(user: current_user))
                   .where.not(id: LostDog.select(:id)  # Lost dogs that haven't been returned
                                  .joins(:delegate)
                                  .where('lost_dog_delegates.returned' => true))
                   .where.not(id: FoundDog.select(:id)  # Found dogs that haven't been returned
                                  .joins(:delegate)
                                  .where('found_dog_delegates.returned' => true))
                   .or(                    # The current user already belongs to the private event
                       Event.where(id: PostEvent.select(:id)
                                                .where(:is_around_me => true)
                                                .joins(:joined_users, :delegate)
                                                .where('post_event_delegates.private' => true, 
                                                       'events_users.user_id' => current_user.id))
                       )
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
      format.json { render "chats/create" }
    end
  end

  def lost_and_found
    @lost_dogs = LostDog.joins(:delegate)
                 .where('lost_dog_delegates.returned' => false)
                 .eager_load(pet: [:breed, :colors, :weight])
                 .order("events.user_id = #{current_user.id} DESC, events.id ASC")
    @found_dogs = FoundDog.joins(:delegate)
                  .where('found_dog_delegates.returned' => false)
                  .eager_load(delegate: [:breed, :colors, :weight])
                  .order("events.user_id = #{current_user.id} DESC, events.id ASC")
  end

  def contact_owner_modal_body
    # http://localhost:3000/users/5/chats?other_user=1
    # Copied code from chat controller
    @other_user = @event.user
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end
    
    @message = Message.new
    respond_to do |format|
      format.js {render :contact_owner_modal_body}
    end
  end
  
  def view_messages_modal_body
    # loop through all of my chats, loop through each chat subscribtions
    @messaging_users = []
    current_user.chats.each do |chat|
      chat.subscriptions.each do |s|
        if s.user != current_user && !@messaging_users.include?(s.user)
          @messaging_users << s.user
        end
      end
    end
    respond_to do |format|
      format.js { render :view_messages_modal_body }
    end
  end
  
  def view_message_from_user_modal_body
    # http://localhost:3000/users/5/chats?other_user=1
    # Copied code from chat controller
    @other_user = User.where(id: params[:other_user]).first
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end
    
    @message = Message.new
    respond_to do |format|
      format.js {render :view_message_from_user_modal_body}
    end
  end
  
  # GET /events/1/join
  # GET /events/1/join.json
  # This will probably only be used for users that are browsing public events that want to join
  def join
    respond_to do |format|
      if @event && !@event.private
        @event.joined_users << current_user unless @event.joined_users.include? current_user
        format.js { render :join }
        format.html { redirect_to event_path(current_user), notice: 'Successfully joined event.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: "Could not leave event", status: :unprocessable_entity }
      end
    end
  end
  
  # GET /events/1/disjoin
  # GET /events/1/disjoin.json
  def disjoin
    @event.joined_users.delete(current_user)  # Just deletes the record from the association
    respond_to do |format|
      format.js { render :disjoin }
      format.html { redirect_to event_path(current_user), notice: 'Successfully left event.' }
      format.json { head :no_content }
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
  
  def find_chat(second_user)
    chats = current_user.chats
    chats.each do |chat|
      chat.subscriptions.each do |s|
        if s.user_id == second_user.id
          return chat
        end
      end
    end
    nil
  end
end
