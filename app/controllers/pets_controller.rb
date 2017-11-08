class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :update, :destroy]

  # GET /pets
  # GET /pets.json
  def index
    @pets = Pet.active
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets
  # POST /pets.json
  def create
    @pet = Pet.new(pet_params)

    respond_to do |format|
      if @pet.save
        format.html { redirect_to @pet, notice: 'Pet was successfully created.' }
        format.js   { render 'pets/create', status: :created }
        format.json { render :show, status: :created, location: @pet }
      else
        if @pet.errors.any?
          error_messages = ["Please fix the following errors:"]
          error_messages << @pet.errors.messages.values
          flash[:error] = error_messages.join('<br/>')
        end
        format.html { render :new }
        format.js   { render 'pets/create', status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1
  # PATCH/PUT /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to groups_pets_path, notice: 'Image successfully upload.' }
        format.js   { render 'pets/update' }
        format.json { render :show, status: :ok, location: @pet }
      else
        if @pet.errors.any?
          error_messages = ["Please fix the following errors:"]
          error_messages << @pet.errors.messages.values
          flash[:error] = error_messages.join('<br/>')
        end
        format.html { render :edit }
        format.js   { render 'pets/update', status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  def destroy
    @pet.update active: false
    respond_to do |format|
      format.js   { render 'pets/destroy' }
      format.html { redirect_to pets_url, notice: 'Pet was successfully removed.' }
      format.json { head :no_content }
    end
  end

  # GET /pets/1/image_modal.json
  def image_modal
    @pet = Pet.where(id: params[:id]).first
    if @pet
      respond_to do |format|
        format.js   { render 'pets/image_modal' }
      end
    else
      respond_to do |format|
        format.js   { render 'pets/image_modal', status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pet_params
      params.require(:pet).permit(:name, :group_id, :breed_id, :weight_id, :chip_number, :image, :image_cache, color_ids: [])
    end
end
