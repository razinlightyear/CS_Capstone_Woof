class HomeController < ApplicationController

  def index
    @user = User.new
  end

  def login
  end

  def create
    @email_address = params[:email_address]
    @password = params[:password]
    redirect_to user_session_path
  end

  def sign_out_profile
    sign_out(@user)
    redirect_to root_path
  end
end
