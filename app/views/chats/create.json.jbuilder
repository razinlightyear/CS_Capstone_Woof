#json.extract! @chat, :id, :messages

json.id @chat.id
json.messages @chat.messages.each do |message|
	json.partial! 'messages/message', message: message
end
