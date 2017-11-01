#json.call(
#    user,
#    :id,
#    :first_name,
#    :last_name,
#    :email,
#    :authentication_token,
#    :image
#)

#unless user.image.thumb.url.nil?
#	json.image user.image
#else
#	json.image image_url "user_placeholder"
#end

json.extract! user, :id, :first_name, :last_name, :email, :authentication_token, :image