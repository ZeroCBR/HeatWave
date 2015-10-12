##
# Messages controller
# a limited version of the standard controller created by the scaffold
# only allows for viewing throught the rails app
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.joins(
      'INNER JOIN users ON users.id = messages.user_id'
      ).order(sort_column + ' ' + sort_direction)

    return @messages if current_user.admin_access
    @messages = @messages.select { |x| x.user == current_user }
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    set_message
    return if current_user.admin_access
    flash[:alert] = 'You may only view messages sent to you'
    redirect_to messages_path unless @message.user == current_user
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  def sort_column
    (Message.column_names + %w(f_name l_name email))
      .include?(params[:sort]) ? params[:sort] : 'send_time'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
