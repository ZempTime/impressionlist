class Connections::ApprovalsController < ApplicationController
  include ConnectionScoped

  def create
    @approval = Connections::Approval.new(current_user, @connection)
    if @approval.save
      redirect_back fallback_location: connections_path
    else
      flash[:alert] = @approval.errors
    end
  end
end