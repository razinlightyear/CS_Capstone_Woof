json.array! @users do |user|
  json.id   user.id
  first = user.first_name
  last = user.last_name
  username = user.email.split('@')[0]
  json.name "#{first}, #{last}, #{username}"
end
