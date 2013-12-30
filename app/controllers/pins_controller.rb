class PinsController < ApplicationController
  before_action :set_pin, only: [:show, :edit, :update, :destroy]
  #added this line to activate the def current_user method
  before_action :correct_user, only: [:edit, :update, :destroy]
  #added this new line to secure the creation of new pins by users not logged in
  #visitor will be able only to see index page and read(show) pins, but not edit or destroy
  #without signing up or logging in!!!
  before_action :authenticate_user!, except: [:index, :show]

  # GET /pins
  # GET /pins.json
  def index
    @pins = Pin.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 4)
  end

  # GET /pins/1
  # GET /pins/1.json
  def show
  end

  # GET /pins/new
  def new
    # @pin = Pin.new //change this line to:
    @pin = current_user.pins.build
  end

  # GET /pins/1/edit
  def edit
  end

  # POST /pins
  # POST /pins.json
  def create
    # @pin = Pin.new(pin_params) //change this to:
    @pin = current_user.pins.build(pin_params)
    if @pin.save
      redirect_to @pin, notice: 'Pin was succesfully created.'
    else
      render action: 'new'
    end

  #comment these lines out 
  #   respond_to do |format|
  #     if @pin.save
  #       format.html { redirect_to @pin, notice: 'Pin was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @pin }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @pin.errors, status: :unprocessable_entity }
  #     end
  #   end
 end

  # PATCH/PUT /pins/1
  # PATCH/PUT /pins/1.json
  def update
    respond_to do |format|
      if @pin.update(pin_params)
        format.html { redirect_to @pin, notice: 'Pin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    @pin.destroy
    respond_to do |format|
      format.html { redirect_to pins_url }
      #format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    #added these new lines to secure editing of someone else pins
    def correct_user
      @pin = current_user.pins.find_by(id: params[:id])
      redirect_to pins_path, notice: "Not authorized to edit this pin" if @pin.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pin_params
      params.require(:pin).permit(:description, :image)
    end
end
