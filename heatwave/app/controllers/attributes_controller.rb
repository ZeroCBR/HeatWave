# Control the attribute page
class AttributesController < ApplicationController
  before_action :set_attribute, only: [:show, :edit, :update, :destroy]

  # GET /attributes
  # GET /attributes.json
  def index
    @attributes = Attribute.all
  end

  # GET /attributes/1
  # GET /attributes/1.json
  def show
  end

  # GET /attributes/new
  def new
    @attribute = Attribute.new
  end

  # GET /attributes/1/edit
  def edit
  end

  # POST /attributes
  # POST /attributes.json
  def create
    @attribute = Attribute.new(attribute_params)
    respond_to do |format|
      if @attribute.save
        format.html do
          redirect_to @attribute, notice: 'Attribute was successfully created.'
        end
        format.json { render :show, status: :created, location: @attribute }
      else
        format.html { render :new }
        format.json do
          render json: @attribute.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /attributes/1
  # PATCH/PUT /attributes/1.json
  def update
    respond_to do |format|
      if @attribute.update(attribute_params)
        format.html do
          redirect_to @attribute, notice: 'Attribute was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @attribute }
      else
        format.html { render :edit }
        format.json do
          render json: @attribute.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /attributes/1
  # DELETE /attributes/1.json
  def destroy
    @attribute.destroy
    respond_to do |format|
      format.html do
        redirect_to attributes_url,
                    notice: 'Attribute was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_attribute
    @attribute = Attribute.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the
  # white list through.
  def attribute_params
    params.require(:attribute).permit(:name, :annotation)
  end
end
