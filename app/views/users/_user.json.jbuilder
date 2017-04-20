json.extract! user, :id, :first_name, :last_name, :email
json.group_ids  user.groups.pluck :id
json.group_names  user.groups.pluck :name
