class ListsController < ApplicationController

  def show
    @list = List.first
  end
end