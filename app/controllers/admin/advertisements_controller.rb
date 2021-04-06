class Admin::AdvertisementsController < ApplicationController
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy]

  # GET /admin/advertisements
  # GET /admin/advertisements.json
  def index
    @advertisements = Advertisement.all
  end

  # GET /admin/advertisements/1
  # GET /admin/advertisements/1.json
  def show
  end

  # GET /admin/advertisements/new
  def new
    @advertisement = Advertisement.new
  end

  # GET /admin/advertisements/1/edit
  def edit
  end

  # POST /admin/advertisements
  # POST /admin/advertisements.json
  def create
    @advertisement = Advertisement.new(advertisement_params)

    respond_to do |format|
      if @advertisement.save
        format.html { redirect_to [:admin, @advertisement], notice: 'Advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/advertisements/1
  # PATCH/PUT /admin/advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        format.html { redirect_to [:admin, @advertisement], notice: 'Advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/advertisements/1
  # DELETE /admin/advertisements/1.json
  def destroy
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to advertisements_url, notice: 'Advertisement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advertisement
      @advertisement = Advertisement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advertisement_params
      params.require(:advertisement).permit(:position, :image_url, :site_url, :expire_at, :name)
    end
end
