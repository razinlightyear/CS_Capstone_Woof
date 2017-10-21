json.array! @group do |user|
    json.call(
        user,
        :user_id,
        :response
    )
end