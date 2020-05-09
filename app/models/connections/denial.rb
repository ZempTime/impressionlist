class Connections::Denial
  include ActiveModel::Validations
  validate :deniable_status

  attr_accessor :user, :oriented_connection, :connection

  def initialize(user, connection)
    @user = user
    @oriented_connection = Connections::OrientedConnection.new(user, connection)
    @connection = connection
  end

  def save
    if valid?
      connection.status = oriented_connection.oriented_from == :one ? :one_deny_two : :two_deny_one
      connection.append_log("user #{oriented_connection.oriented_from} denied connection\n")
      connection.save
      true
    else
      false
    end
  end

  protected
    def deniable_status
      unless oriented_connection.deniable?
        errors.add(:connection, "This connection isn't one that can be approved right now")
      end
    end
end