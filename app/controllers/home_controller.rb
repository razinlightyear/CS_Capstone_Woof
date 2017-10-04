class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @homepage = true
    if @user.nil?
      @user = User.new
    end
  end

  def login
  end

  def create
    redirect_to user_session_path
  end

  def sign_out_profile
    sign_out(@user)
    redirect_to root_path
  end
end
