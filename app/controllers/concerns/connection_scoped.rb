module ConnectionScoped
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_connection
  end

  protected
    def set_connection
      @connection = current_user.connections.where(id: params[:connection_id]).first
      unless @connection
        redirect_to root_path, notice: "No connection found for this user"
      end
    end
end