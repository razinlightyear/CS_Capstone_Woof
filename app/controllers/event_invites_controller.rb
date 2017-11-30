class EventInvitesController < ApplicationController
  before_action :set_event_invite, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:accept, :decline]

  # POST /event_invites
  # POST /event_invites.json
  # Expects parameters :invitee_id, :event_id (:inviter is current user)
  def create
    if User.active.where(id: event_invite_params[:invitee_id]).any? # They selected a public user from the dropdown
      Rails.logger.debug "Case 1. They selected a public user from the dropdown"
      @event_invite = EventInvite.new(event_invite_params.merge({inviter: current_user}))
      respond_to do |format|
        if @event_invite.save
          UserMailer.event_invite(@event_invite).deliver_later
          format.html { redirect_to event_path(current_user), notice: 'Invite was successfully sent.' }
          format.js { render :create, status: :created }
        else
          if @event_invite.errors.any?
            error_messages = ["Please fix the following errors with the invite:"]
            error_messages << @event_invite.errors.messages.values
            flash[:error] = error_messages.join('<br/>')
          end
          format.html { redirect_to event_path(current_user) }
        end
      end
    elsif User.active.user_not_in_event(event_invite_params[:invitee_id], event_invite_params[:event_id]).any? # The user is private. They entered an email that they know but the :invitee_id is just the name and not the id
      Rails.logger.debug "Case 2. The user is private. They entered an email that they know"
      private_user = User.active.user_not_in_event(event_invite_params[:invitee_id], event_invite_params[:event_id]).first
      @event_invite = EventInvite.new(invitee: private_user, inviter: current_user, event_id: event_invite_params[:event_id])
      respond_to do |format|
        if @event_invite.save
          UserMailer.event_invite(@event_invite).deliver_later
          format.html { redirect_to event_path(current_user), notice: 'Invite was successfully sent.' }
        else
          if @event_invite.errors.any?
            error_messages = ["Please fix the following errors with the invite:"]
            error_messages << @event_invite.errors.messages.values
            flash[:error] = error_messages.join('<br/>')
          end
          format.html { redirect_to event_path(current_user) }
        end
      end
    else # The user doesn't exist. Send an error message
      Rails.logger.debug "Case 3. User doesn't exist."
      respond_to do |format|
        Rails.logger.debug "Cannot invite user to event because the user doesn't exist."
        format.html { redirect_to event_path(current_user), error: "Cannot invite user to event because the user doesn't exist." }
        return
      end
    end
  end
  
  # GET /event_invites/accept?invite_token=UI345UH98G55S
  def accept
    respond_to do |format|
      not_found("Bad Link") and return unless params[:invite_token]
      @invite = EventInvite.where(invite_token: params[:invite_token], accepted_at: nil, declined_at: nil)
                           .eager_load(:event, :invitee, :inviter).first
      unless @invite
        puts "Invitation has closed"
        flash[:error] = "Invitation has closed"
        redirect_to groups_pets_path
        return
      end
      if current_user && current_user != @invite.invitee
        puts "This link was created for another user"
        flash[:error] = "This link was created for another user"
        redirect_to root_path
        return
      end
      sign_in @invite.invitee
      @invite.accepted_at = Time.now.utc
      @invite.event.joined_users << @invite.invitee
      invite_save = @invite.save
      event_save = @invite.event.save
      if invite_save && event_save
        puts "You have succesfully joined the event"
        format.html { redirect_to event_path(current_user), notice: "You have succesfully joined the event" }
      else
        puts "The following errors prevented you from joining the event"
        error_messages = ["The following errors prevented you from joining the event"]
        error_messages << @invite.errors.messages.values if @invite.errors.any?
        error_messages << @invite.event.errors.messages.values if @invite.event.errors.any?
        flash[:error] = error_messages.join('<br/>')
        format.html { redirect_to event_path(current_user) }
      end
    end
  end
  
  # GET /event_invites/accept?invite_token=UI345UH98G55S
  def decline
    respond_to do |format|
      not_found("Bad Link") and return unless params[:invite_token]
      @invite = EventInvite.where(invite_token: params[:invite_token], accepted_at: nil, declined_at: nil)
                           .eager_load(:event, :invitee, :inviter).first
      unless @invite
        puts "Invitation has closed"
        flash[:error] = "Invitation has closed"
        redirect_to event_path(current_user)
        return
      end
      if current_user && current_user != @invite.invitee
        puts "This link was created for another user"
        flash[:error] = "This link was created for another user"
        redirect_to root_path
        return
      end
      @invite.declined_at = Time.now.utc
      invite_save = @invite.save
      if invite_save
        Rails.logger.debug "Event invite declined"
        format.html { redirect_to event_path(current_user), notice: "Event invitation declined" }
      else
        Rails.logger.debug "Event invite couldn't be declined"
        error_messages = ["Event invite couldn't be declined"]
        error_messages << @invite.errors.messages.values if @invite.errors.any?
        flash[:error] = error_messages.join('<br/>')
        format.html { redirect_to event_path(current_user) }
      end
    end
  end
  
  # PATCH/PUT /event_invites/1
  # PATCH/PUT /event_invites/1.json
  def update
    respond_to do |format|
      if @event_invite.update(event_invite_params)
        format.html { redirect_to @event_invite, notice: 'Event invite was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_invite }
      else
        format.html { render :edit }
        format.json { render json: @event_invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_invites/1
  # DELETE /event_invites/1.json
  def destroy
    @event_invite.destroy
    respond_to do |format|
      format.html { redirect_to event_path(current_user), notice: 'Invite cancelled.' }
      format.json { head :no_content }
    end
  end

  # DELETE /event_invites/1
  # DELETE /event_invites/1.json
  def destroy
    @event_invite.destroy
    respond_to do |format|
      format.html { redirect_to event_path(current_user), notice: 'Invite cancelled.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_invite
      @event_invite = EventInvite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_invite_params
      params.require(:event_invite).permit(:invitee, :inviter, :event, :invitee_id, :inviter_id, :event_id)
    end
end
