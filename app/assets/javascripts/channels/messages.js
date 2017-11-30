function createMessageChannel() {
  // Check the list of subscriptions to see if the subscription we need is already created
  // (If this doesn't work in the future, we may also need to check the state of the subscription to see if it is disconnected)
  for(var i = 0; i < App.cable.subscriptions.subscriptions.length; i++) {
    if(JSON.parse(App.cable.subscriptions.subscriptions[i].identifier).chat_id == parseInt($("#message_chat_id").val())) {
      App.messages = App.cable.subscriptions.subscriptions[i];
      return App.messages;
    }
  }
  App.messages = App.cable.subscriptions.create({
      channel: 'MessagesChannel', chat_id: parseInt($("#message_chat_id").val())
    },
    {
      received: function(data) {
          $("#messages").removeClass('hidden')
          return $('#messages').append(this.renderMessage(data));
        },
      renderMessage: function(data) {
          return "<p> <b>" + data.user + ": </b>" + data.message + "</p>";
    },
  });
  return App.messages;
}