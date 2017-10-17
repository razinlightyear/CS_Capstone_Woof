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

            # Store the Apple device token
            device = Device.where(user_id: @user.id, device_token: params[:device_token]).first
            if device.nil?
                device = Device.new
                device.device_token = params[:device_token]
                device.user_id = @user.id
                device.save
            end

            render :create, status: :created
        else
            head(:unauthorized)
        end
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