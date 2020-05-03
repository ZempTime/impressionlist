class Connections::Approval
  include ActiveModel::Validations
  validate :other_requested
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
    def other_requested
      unless oriented_connection.other_requested?
        errors.add(:connection, "You can only approve connections requested by the other user")
      end
    end

    def approvable_status
      unless oriented_connection.approvable?
        errors.add(:connection, "This connection isn't one that can be approved right now")
      end
    end
end