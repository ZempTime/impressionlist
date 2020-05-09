class ConnectionsController < ApplicationController
  def index
    @presenter = Connections::IndexPresenter.new(current_user)
  end

  def new
    @connection = Connections::Create.new
  end

  def create
    @connection = Connections::Create.new connection_params
    @connection.current_user = current_user

    if @connection.save
      redirect_to connections_path
    else
      render :new
    end
  end

  protected
    def connection_params
      params.require(:connection).permit(:other_user_email)
    end
end