class Connections::Approval
  include ActiveModel::Validations
  validate :approvable_status

  attr_accessor :user, :oriented_connection, :connection

  def initialize(user, connection)
    @user = user
    @oriented_connection = Connections::OrientedConnection.new(user, connection)
    @connection = connection
  end

  def save
    if valid?
      connection.status = :friends
      connection.append_log("user #{oriented_connection.oriented_from} approved to become friends\n")
      connection.save
      true
    else
      false
    end
  end

  protected
    def approvable_status
      unless oriented_connection.approvable?
        errors.add(:connection, "This connection isn't one that can be approved right now")
      end
    end
end