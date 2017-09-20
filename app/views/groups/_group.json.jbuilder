json.extract! group, :id, :name, :created_at, :updated_at
json.owner group.owner, partial: "users/user", as: :user
