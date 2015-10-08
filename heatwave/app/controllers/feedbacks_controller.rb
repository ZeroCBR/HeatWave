# Control the feedback page
class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :destroy]
  before_action :admin_user!, only: [:index, :show, :destroy]

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show; end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)
    respond_to do |format|
      if @feedback.save
        format.html do
          redirect_to @feedback, notice: 'Feedback was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  # DELETE /feedbacks/1
  def destroy
    respond_to do |format|
      format.html do
        if @feedback.update responded: true
          redirect_to @feedback, notice: 'Feedback marked as responded to.'
        else
          flash.now[:alert] = 'Failed to mark feedback as responded to.'
          render :index
        end
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feedback
    @feedback = Feedback.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the
  # white list through.
  def feedback_params
    params.require(:feedback).permit(:title, :content, :comment, :responded)
  end
end
