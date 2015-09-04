# Control the history page
class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy]

  # GET /histories
  # GET /histories.json
  def index
    @histories = History.all
  end

  # GET /histories/1
  # GET /histories/1.json
  def show
  end

  # GET /histories/new
  def new
    @history = History.new
  end

  # GET /histories/1/edit
  def edit
  end

  # POST /histories
  # POST /histories.json
  def create
    @history = History.new(history_params)

    respond_to do |format|
      if @history.save
        format.html do
          redirect_to @history, notice: 'History was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /histories/1
  # PATCH/PUT /histories/1.json
  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html do
          redirect_to @history, notice: 'History was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /histories/1
  # DELETE /histories/1.json
  def destroy
    @history.destroy
    respond_to do |format|
      format.html do
        redirect_to histories_url,
                    notice: 'History was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_history
    @history = History.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the
  # white list through.
  def history_params
    params.require(:history).permit(:title, :content)
  end
end
