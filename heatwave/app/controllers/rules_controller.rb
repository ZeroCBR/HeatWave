# Control the rule page
class RulesController < ApplicationController
  before_action :set_rule, only: [:show, :edit, :update, :destroy]
  before_action(:admin_user!,
                only: [:index, :new, :edit, :create, :update, :destroy])

  # GET /rules
  # GET /rules.json
  def index
    @rules = Rule.all
  end

  # GET /rules/1
  def show
  end

  # POST /rules
  def create
    @rule = Rule.new(rule_params)
    respond_to do |format|
      html_respond_to(format, 'create', 'created', :new) { @rule.save }
    end
  end

  # PATCH/PUT /rules/1
  def update
    respond_to do |format|
      html_respond_to(format, 'update', 'updated', :edit) \
        { @rule.update(rule_params) }
    end
  end

  # DELETE /rules/1
  def destroy
    respond_to do |format|
      html_respond_to(format, 'deactivate', 'deactivated', :show) \
        { @rule.update(activated: false) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rule
    @rule = Rule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the
  # white list through.
  def rule_params
    params.require(:rule).permit(:name, :activated, :delta, :duration,
                                 :key_advice, :full_advice)
  end

  def html_respond_to(format, present_tense, past_tense, alternative)
    if yield
      format.html do
        redirect_to @rule, notice: "Successfully #{past_tense} rule"
      end
    else
      format.html do
        flash.now[:alert] = "Failed to #{present_tense} rule"
        render alternative
      end
    end
  end
end
