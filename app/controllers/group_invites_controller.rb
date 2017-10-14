class GroupInvitesController < ApplicationController
  before_action :set_group_invite, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @group_invites = GroupInvite.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group_invite = GroupInvite.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group_invite = GroupInvite.new(group_invite_params.merge({inviter: current_user}))

    respond_to do |format|
      if @group_invite.save
        current_user.groups << @group_invite.group
        current_user.save!
        @user = current_user
        @groups = Group.joins(:groups_users)
                       .where('groups_users.user_id' => @user.id)
                       .eager_load(:users, group_invites: [:invitee, :inviter], pets: [:breed,:colors,:weight])
        format.html { redirect_to profile_path, notice: 'Invite was successfully created.' }
        format.js { render 'groups/create', status: :created }
        format.json { render :show, status: :created, location: @group_invite }
      else
        @user = current_user
        @groups = Group.joins(:groups_users)
                       .where('groups_users.user_id' => @user.id)
                       .eager_load(:users, group_invites: [:invitee, :inviter], pets: [:breed,:colors,:weight])
        if @group_invite.errors.any?
          error_messages = ["Please fix the following errors with the invite:"]
          error_messages << @group_invite.errors.messages.values
          flash[:error] = error_messages.join('<br/>')
        end
        format.html { redirect_to profile_path }
        format.json { render json: @group_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group_invite.update(group_invite_params)
        format.html { redirect_to @group_invite, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_invite }
      else
        format.html { render :edit }
        format.json { render json: @group_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group_invite.destroy
    @user = User.find(current_user)
    @groups = Group.joins(:groups_users)
                   .where('groups_users.user_id' => @user.id)
                   .eager_load(:users, group_invites: [:invitee, :inviter], pets: [:breed,:colors,:weight])
    respond_to do |format|
      format.html { redirect_to profile_path, notice: 'Invite cancelled.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_invite
      @group_invite = GroupInvite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_invite_params
      params.require(:group_invite).permit(:invitee, :inviter, :group, :invitee_id, :inviter_id, :group_id)
    end
end
