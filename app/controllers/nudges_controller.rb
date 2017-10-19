class NudgesController < ApplicationController
  before_action :set_nudge, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:create, :update, :group_nudge]

  # GET /nudges/1
  # GET /nudges/1.json
  def show
  end

  # POST /nudges
  # POST /nudges.json
  def create
    # Create Nudge for issueing user
    @nudge = Nudge.new
    @nudge.user_id = params[:user_id]
    @nudge.pet_id = params[:pet_id]
    @nudge.group_id = params[:group_id]
    @nudge.response = -1
    @nudge.nudge_token = @nudge.generate_token

    respond_to do |format|
      if @nudge.save
        # Create Nudge for group memebers
        Group.find(params[:group_id]).users.each do |user|
          next if user.id == @nudge.user_id
          @nudge_member = Nudge.new
          @nudge_member.user_id = user.id
          @nudge_member.pet_id = params[:pet_id]
          @nudge_member.group_id = params[:group_id]
          @nudge_member.response = 0
          @nudge_member.nudge_token = @nudge.nudge_token

          if @nudge_member.save
            # Send push notification
            @apn = Houston::Client.development
            device_token = User.find(@nudge_member.user_id).devices.first.device_token
            notification = Houston::Notification.new(device: device_token)
            notification.alert = User.find(@nudge.user_id).first_name + ': Has ' + Pet.find(@nudge.pet_id).name + ' been fed?'
            notification.category = 'fed.category'
            notification.content_available = true
            notification.sound = 'sosumi.aiff'
            notification.custom_data = { nudge_id: @nudge.id, nudge_token: @nudge.nudge_token }
            @apn.push(notification)
          end
        end
        format.json { render :show, status: :created, location: @nudge }
      else
        format.json { render json: @nudge.errors, status: :unprocessable_entity }
      end    
    end
  end

  # PATCH/PUT /nudges/1
  # PATCH/PUT /nudges/1.json
  def update
    respond_to do |format|
      if Nudge.where(:nudge_token => params[:nudge_token], :user_id => params[:user_id]).first.update(:response => params[:response])
        # Find asking user
        asking_nudge = Nudge.where(:nudge_token => params[:nudge_token], :response => -1).first

        # Send push notification
        response = ''
        if params[:response] == "1"
          response = 'Yes, ' + Pet.find(asking_nudge.pet_id).name + ' is fed.'
        elsif params[:response] == "2"
          response = 'No, ' + Pet.find(asking_nudge.pet_id).name + " isn't fed."
        elsif params[:response] == "3"
          response = "I don't know if " + Pet.find(asking_nudge.pet_id).name + ' is fed.'
        end

        @apn = Houston::Client.development
        device_token = User.find(asking_nudge.user_id).devices.first.device_token
        notification = Houston::Notification.new(device: device_token)
        notification.alert = User.find(params[:user_id]).first_name + ' responded: ' + response
        notification.sound = 'sosumi.aiff'
        notification.custom_data = { nudge_id: @nudge.id, nudge_token: @nudge.nudge_token, response: params[:response] }
        @apn.push(notification)

        format.json { render :show, status: :ok, location: @nudge }
      else
        format.json { render json: @nudge.errors, status: :unprocessable_entity }
      end
    end
  end

  def group_nudge
    @group = Group.find(params[:group_id]).nudges.where(:created_at => Group.find(params[:group_id]).nudges.last.created_at)

    render :responses, status: :created
  end

  # DELETE /nudges/1
  # DELETE /nudges/1.json
  def destroy
    @nudge.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nudge
      @nudge = Nudge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nudge_params
      params.require(:nudge).permit(:nudge_token, :user_id, :pet_id, :group_id, :response)
    end
end
