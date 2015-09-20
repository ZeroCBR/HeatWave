# Control the rule page
class RulesController < ApplicationController
  before_action :set_rule, only: [:show, :edit, :update, :destroy]

  # GET /rules
  # GET /rules.json
  def index
    @rules = Rule.all
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
  end

  # GET /rules/new
  def new
    @rule = Rule.new
  end

  # GET /rules/1/edit
  def edit
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = Rule.new(rule_params)
    respond_to do |format|
      if @rule.save
        format.html do
          redirect_to @rule, notice: 'Rule was successfully created.'
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /rules/1
  # PATCH/PUT /rules/1.json
  def update
    respond_to do |format|
      if @rule.update(rule_params)
        format.html do
          redirect_to @rule, notice: 'Rule was successfully updated.'
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @rule.destroy
    respond_to do |format|
      format.html do
        redirect_to rules_url, notice: 'Rule was successfully destroyed.'
      end
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
    params.require(:rule).permit(:name, :annotation, :delta, :duration)
  end
end
