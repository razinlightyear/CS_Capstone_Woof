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
  # Expects parameters :invitee_id, :group_id (:inviter is current user)
  def create
    if !User.where(id: group_invite_params[:invitee_id]).empty? # They selected a public user from the dropdown
      Rails.logger.debug "Case 1. They selected a public user from the dropdown"
      @group_invite = GroupInvite.new(group_invite_params.merge({inviter: current_user}))
      respond_to do |format|
        if @group_invite.save
          current_user.groups << @group_invite.group
          current_user.save!
          UserMailer.group_invite(@group_invite).deliver_later
          format.html { redirect_to profile_path, notice: 'Invite was successfully created.' }
        else
          if @group_invite.errors.any?
            error_messages = ["Please fix the following errors with the invite:"]
            error_messages << @group_invite.errors.messages.values
            flash[:error] = error_messages.join('<br/>')
          end
          format.html { redirect_to profile_path }
        end
      end
    elsif !User.active.contains_not_in_group(group_invite_params[:invitee_id], group_invite_params[:group_id]).empty? # The user is private. They entered an email that they know
      Rails.logger.debug "Case 2. The user is private. They entered an email that they know"
      private_user = User.active.user_not_in_group(group_invite_params[:invitee_id], group_invite_params[:group_id]).first
      @group_invite = GroupInvite.new(invitee: private_user, inviter: current_user, group_id: group_invite_params[:group_id])
      respond_to do |format|
        if @group_invite.save
          current_user.groups << @group_invite.group
          current_user.save!
          UserMailer.group_invite(@group_invite).deliver_later
          format.html { redirect_to profile_path, notice: 'Invite was successfully created.' }
        else
          if @group_invite.errors.any?
            error_messages = ["Please fix the following errors with the invite:"]
            error_messages << @group_invite.errors.messages.values
            flash[:error] = error_messages.join('<br/>')
          end
          format.html { redirect_to profile_path }
        end
      end
    else # The user doesn't exist. We need to send them an invite to join Woof. Woof Woof
      # Create a new User record with just their with email, no password, and create a  group invite record for the user. Auto confirm the user if the user accepts the invite from the email.
      Rails.logger.debug "Case 3. Create a new User record with just their with email."
      @invite_token = Devise.friendly_token
      new_user_attributes = {
        email: group_invite_params[:invitee_id],
        active: false,
        confirmation_token: @invite_token,
        confirmation_sent_at: Time.now.utc
      }
      @user = User.new(new_user_attributes)
      respond_to do |format|
        @user.transaction do
          begin
            @user.save!
            attributes = {
              inviter: current_user,
              invitee: @user,
              group_id: group_invite_params[:group_id],
              invite_token: @invite_token
            }
            @group_invite = GroupInvite.create!(attributes)
            @user.skip_confirmation_notification! # Devise will try to send a registration email
            UserMailer.group_invite_new_user(@group_invite).deliver_later
            format.html { redirect_to profile_path, notice: 'Invite was successfully created.' }
          rescue ActiveRecord::Rollback
            if @group_invite.errors.any?
              error_messages = ["Please fix the following errors with the invite:"]
              error_messages << @group_invite.errors.messages.values
              flash[:error] = error_messages.join('<br/>')
            end
            format.html { redirect_to profile_path }
            raise ActiveRecord::Rollback
          end
        end
      end
    end
  end

  # GET /group_invites/accept?invite_token=UI345UH98G55S
  def accept
    respond_to do |format|
      not_found("Bad Link") and return unless params[:invite_token]
      @invite = GroupInvite.where(invite_token: params[:invite_token], accepted_at: nil, declined_at: nil)
                           .eager_load(:group, :invitee, :inviter).first
      unless @invite
        flash[:error] = "Invitation has closed"
        format.html { redirect_to profile_path }
        return
      end
      not_found("This link was created for another user") if current_user && current_user != @invite.invitee
      @invite.accepted_at = Time.now.utc
      @invite.group.users << @invite.invitee
      user_save = @invite.save
      group_save = @invite.group.save
      if user_save && group_save
        format.html { redirect_to profile_path, notice: "You have succesfully joined group: #{@invite.group.name}" }
      else
        error_messages = ["The following errors prevented you from joining the group: #{@invite.group.name}"]
        error_messages << @invite.errors.messages.values if @invite.errors.any?
        error_messages << @invite.errors.messages.values if @invite.group.errors.any?
        flash[:error] = error_messages.join('<br/>')
        format.html { redirect_to profile_path }
      end
    end
  end
  
  # GET /group_invites/accept?invite_token=UI345UH98G55S
  def decline
    raise NotImplementedError
  end
  
  # GET /group_invites/accept_new?invite_token=UI345UH98G55S
  def accept_new
    raise NotImplementedError
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
