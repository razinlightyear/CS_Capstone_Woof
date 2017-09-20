class FeedingHistoriesController < ApplicationController
  before_action :set_feeding_history, only: [:show, :edit, :update, :destroy]

  # GET /groups/1/feeding_histories
  # GET /groups/1/feeding_histories.json
  def index
    if params[:group_id]
      @feeding_histories = FeedingHistory.includes(:delegate, pet: [:breed, :colors, :weight]).references(:delegate, pet: [:breed, :colors, :weight]).where('pets.group' =>  params[:group_id])
    elsif params[:pet_id]
      @feeding_histories = FeedingHistory.includes(:delegate, pet: [:breed, :colors, :weight]).references(:delegate, pet: [:breed, :colors, :weight]).where('pets.id' =>  params[:pet_id])
    else
      @feeding_histories = FeedingHistory.includes(:delegate, pet: [:breed, :colors, :weight]).references(:delegate, pet: [:breed, :colors, :weight])
    end
  end

  # GET /feeding_histories/1
  # GET /feeding_histories/1.json
  def show
  end

  # GET /feeding_histories/new
  def new
    @feeding_history = FeedingHistory.new
  end

  # GET /feeding_histories/1/edit
  def edit
  end

  # POST /feeding_histories
  # POST /feeding_histories.json
  def create
    @user = User.first
    puts feeding_history_params.inspect
    @feeding_history = FeedingHistory.new(feeding_history_params.merge(user: @user))

    respond_to do |format|
      if @feeding_history.save
        #format.html { redirect_to @feeding_history, notice: 'Feeding history was successfully created.' }
        format.json { render :show, status: :created, location: @feeding_history }
      else
        #format.html { render :new }
        format.json { render json: @feeding_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT feeding_histories/1
  # PATCH/PUT feeding_histories/1.json
  def update
    respond_to do |format|
      if @feeding_history.update(feeding_history_params)
        format.html { redirect_to @feeding_history, notice: 'Feeding history was successfully updated.' }
        format.json { render :show, status: :ok, location: @feeding_history }
      else
        format.html { render :edit }
        format.json { render json: @feeding_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeding_histories/1
  # DELETE /feeding_histories/1.json
  def destroy
    raise "Not allowed"
    @feeding_history.destroy
    respond_to do |format|
      format.html { redirect_to group_feeding_histories_url(params[:group_id]), notice: 'Feeding history was successfully destroyed.' }
      format.json { head :no_content }  
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feeding_history
      @feeding_history = FeedingHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feeding_history_params
      params.require(:feeding_history).permit(:amount, :food_item, :pet_id)
    end 
end