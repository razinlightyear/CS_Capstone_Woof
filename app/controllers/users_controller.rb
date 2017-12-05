class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_password]
  skip_before_action :authenticate_user!, only: :new_invited_user
  # before any of the below specified methods are exceuted, its going to do the above statement.
    # incase of user, before any of the four methods ar eexectued, it is going to run before_action.
    # look into rails log, when you make a request to Users option and then click on a particular user say, "Paarth", then the parameter pertaining to Paarth would
    # be forwarded to the new page. In case of 'paarth' parameters: {"id" => 4} would be forwarded to the new page.
    # def show doesn't do anything but before show happens, the user_params function is called which gets the user pertaining to the user id.
      # in the log, therefore, you can see the database query.


  # GET /users
  # GET /users.json
  def index
    @users = User.all.eager_load(:groups, :owns_groups)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
        
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|

      # below line calls a function, user_param(). user_param() does the validation. it sees whether the user entered the correct params. We dont't want the current user to put any params and do a request. only correct params should be allowed
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    raise "Action Not Allowed"
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def groups_pets
    @user = current_user
    @groups = Group.joins(:groups_users)
                   .where('groups_users.user_id' => @user.id)
                   .eager_load(:users, group_invites: [:invitee, :inviter], pets: [:breed,:colors,:weight])
                   .where('users.active' => true)
                   #.where('group_invites.accepted_at' => nil, 'group_invites.declined_at' => nil, 'users.active' => true)
  end

  # for purpose for invitee and editing the form
  # GET /profile get the profile for user. 'Edit' button on the form goes to
  # GET /profile/edit This page will have editable form elements and update button on this form will go to
  # POST /profile/update wherein the user would be updated

  # GET /profile
  def profile
    @user = current_user
    @user_profile = true
    @group_invite_count = GroupInvite.where(inviter: @user).count
    @group_invite_accpeted_count = GroupInvite.where(inviter: @user).where.not(accepted_at: nil).count
    @event_count = Event.where(user: @user).count
    @event_invites = EventInvite.where(inviter: current_user).count
    @event_invite_accpeted_count = EventInvite.where(inviter: @user).where.not(accepted_at: nil).count
    @message_count = Message.where(user: @user).count
    @feed_count = FeedingHistory.where(user: current_user).count
  end

  # GET /profile/edit
  def profile_edit
    @user = current_user
    @user_profile = true
  end

  # POST /profile/update
  def profile_update
    # This should be always current_user, correct?
    @new_credentials = params[:user]
    #@user = User.find(@new_credentials["user_id"])
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path
    else
      error_messages = ["Couldn't update your profile for the following reasons"]
      error_messages << @user.errors.messages.values
      flash[:error] = error_messages.join('<br/>')
      render :profile_edit
    end
  end

  # look at font awesome for the icon on the homepage

  # GET /users/find.json?name='diego'
  def find
    respond_to do |format|
      if params[:name] && params[:group_id]
        @users = User.contains_not_in_group(params[:name],params[:group_id])
      elsif params[:name] && params[:event_id]
        @users = User.contains_not_in_event(params[:name],params[:event_id])
      else
        @users = User.all.limit 100
      end
      format.json { render :find }
    end
  end
  
  # GET /update_password
  # PATCH /update_password
  def update_password
    @user_profile = true
    if request.patch?
      if @user.update_with_password(user_params)  # Only :password and :password_confirmation are sent to this action
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(@user)
        flash[:notice] = "Password successfully changed."
        redirect_to root_path
      else
        if @user.errors.any?
          error_messages = ["Password could not be updated:"]
          error_messages << @user.errors.messages.values
          flash[:error] = error_messages.join('<br/>')
        end
        render "update_password"
      end
    end
  end
  
  # We need another action because the new user has to also change their password
  # GET /new_invited_user
  # PATCH /new_invited_user
  def new_invited_user
    if request.patch?
      @user = current_user
      if @user.update(user_params)
        # Sign in the user by passing validation in case their password changed
        bypass_sign_in(@user)
        flash[:notice] = "Profile successfully created."
        redirect_to profile_path
      else
        if @user.errors.any?
          error_messages = ["Couldn't update your profile for the following reasons:"]
          error_messages << @user.errors.messages.values
          flash[:error] = error_messages.join('<br/>')
        end
        render 'new_invited_user'
      end
    end
  end
  
  # GET /users/1/image_modal
  def image_modal
    @user = User.find(params[:id])
    if @user
      respond_to do |format|
        format.js   { render 'users/image_modal' }
      end
    else
      respond_to do |format|
        format.js   { render 'users/image_modal', status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    # callbacks for models and controllers. in models, use them for validation. you can do rich validation on them: when was it created, after it is updated.
    # it makes sure that the user exists in the database.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :active, :image, :image_cache, :current_password)
    end
end
