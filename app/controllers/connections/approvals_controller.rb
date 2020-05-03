class Connections::ApprovalsController < ApplicationController
  before_action :set_connection

  def create
    @approval = Connections::Approval.new(current_user, @connection)
    if @approval.save
      redirect_back fallback_location: connections_path
    else
      flash[:alert] = @approval.errors
    end
  end

  protected
    def set_connection
      @connection = current_user.connections.where(id: params[:connection_id]).first
    end
end