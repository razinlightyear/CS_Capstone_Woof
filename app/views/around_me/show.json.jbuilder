json.user_id @user.id
json.user_email @user.email
json.user_first_name @user.first_name
json.user_last_name @user.last_name
json.around_me_events do
  json.partial! "around_me/index", around_me_events: @around_me_events
end