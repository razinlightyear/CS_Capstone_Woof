json.user do
        json.partial! 'user_info', user: @user
        json.groups do
            json.array! @user.groups do |group|
                json.call(
                    group,
                    :id, 
                    :name
                )
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