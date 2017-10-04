class IosSessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:create]

    # POST /ios/sign_up
    def new
        user = User.new
        user.first_name = params[:user][:first_name]
        user.last_name = params[:user][:last_name]
        user.email = params[:user][:email]
        user.password = params[:user][:password]

        if user.save
            render json: user.as_json(only: [:email, :authentication_token]), status: :created
            #render json: user.to_json
        end
    end

    # Sign In
    def create
        @user = User.where(email: params[:email]).first  

        if @user.valid_password?(params[:password])
            #render json: @user.as_json(only: [:email, :authentication_token]), status: :created
            render :create, status: :created
        else
            head(:unauthorized)
        end

         @apn = Houston::Client.development

        notification = Houston::Notification.new(device: "B5473A07907D62AF91CC4273019A572972DE43BAAB6F65F57B122EBE0A109136")
        notification.alert = 'What up, World!'

        @apn.push(notification)
    end

    def destroy
        current_user && current_user.authentication_token = nil

        if current_user.save
            head(:ok)
        else
            head(:unauthorized)
        end
    end
end