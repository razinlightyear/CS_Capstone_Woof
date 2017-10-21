json.user do
        json.partial! 'user_info', user: @user
        json.groups do
            json.array! @user.groups do |group|
                json.call(
                    group,
                    :id, 
                    :name
                )
                json.users do
                    json.array! group.users do |group_user|
                        next if group_user.id == @user.id
                        json.call(
                            group_user,
                            :id,
                            :first_name,
                            :last_name
                        )
                    end
                end
                json.pets do
                    json.array! group.pets do |pet| 
                        json.call(
                            pet,
                            :name,
                            :id
                        )
                    end
                end
            end
        end
end