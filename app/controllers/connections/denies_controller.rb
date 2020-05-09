class Connections::DeniesController < ApplicationController
  include ConnectionScoped

  def create
    @denial= Connections::Denial.new(current_user, @connection)
    if @denial.save
      redirect_back fallback_location: connections_path
    else
      flash[:alert] = @denial.errors
    end
  end
end