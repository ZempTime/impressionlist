class ConnectionsController < ApplicationController
  def index
    @presenter = Connections::IndexPresenter.new(current_user)
  end
end