class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
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

  def profile
    @user = User.find(current_user)
    @groups = Group.joins(:groups_users)
                   .where('groups_users.user_id' => @user.id)
                   .eager_load(:users, group_invites: [:invitee, :inviter], pets: [:breed,:colors,:weight])
  end

  # GET /users/find.json?name='diego'
  def find
    respond_to do |format|
      if params[:name] && params[:group_id]
        @users = User.contains_not_in_group(params[:name],params[:group_id])
      else
        @users = User.all.limit 100
      end
      format.json { render :find }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    # callbacks for models and controllers. in models, use them for validation. you can do rich validation on them: when was it created, after it is updated.
    # it makes sure that the user exists in the database.
    def set_user
      @user = User.find(current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
