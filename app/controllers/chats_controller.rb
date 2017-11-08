class ChatsController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:create, :update, :group_nudge]

  def index
    chats = current_user.chats
    @existing_chats_users = User.all #current_user.existing_chats_users
  end

  def create
    @other_user = User.find(params[:other_user])
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end

    respond_to do |format|
      format.html { redirect_to user_chat_path(current_user, @chat,  :other_user => @other_user.id) }
      format.json { render :create, status: :created }
    end    
  end

  def show
    @other_user = User.find(params[:other_user])
    @chat = Chat.find_by(id: params[:id])
    @message = Message.new
  end

private
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

  def require_login
    redirect_to new_session_path unless logged_in?
  end
end