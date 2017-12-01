class MessagesController < ApplicationController
def create
    message = Message.new(message_params)
    message.user = current_user

    unless message.user.image.thumb.url.nil?
      @message_user_image_url = message.user.image.thumb.url;
    else
      @message_user_image_url = "user_placeholder";
    end

if message.save
      #broadcasting out to messages channel including the chat_id so messages are broadcasted to specific chat only
      ActionCable.server.broadcast( "messages_#{message_params[:chat_id]}",
      #message and user hold the data we render on the page using javascript 
      message: message.content,
      user: message.user.first_name,
      user_id: message.user.id,
      message_user_image_url: @message_user_image_url
      )
    else
      redirect_to chats_path
    end
  end
private
    def message_params
      params.require(:message).permit(:content, :chat_id)
    end
end