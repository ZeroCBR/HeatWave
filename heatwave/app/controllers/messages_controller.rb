##
# Messages controller
# a limited version of the standard controller created by the scaffold
# only allows for viewing throught the rails app
class MessagesController < ApplicationController
  before_action :set_message
  before_action :admin_user!

  helper_method :sort_column, :sort_direction
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.order(sort_column + ' ' + sort_direction)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  def sort_column
    Message.column_names.include?(params[:sort]) ? params[:sort] : 'send_time'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
