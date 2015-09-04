# Control the feedback page
class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
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

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html do
          redirect_to @feedback, notice: 'Feedback was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html do
        redirect_to(feedbacks_url,
                    notice: 'Feedback was successfully destroyed.')
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
