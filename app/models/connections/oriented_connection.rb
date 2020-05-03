class Connections::OrientedConnection
  attr_reader :user, :connection, :other, :oriented_from

  def initialize(user, connection)
    @connection = connection
    @user = user
    set_orientation
  end

  def other_requested?
    if oriented_from == :one
      connection.two_pending_one? ? true : false
    elsif oriented_from == :two
      connection.one_pending_two? ? true : false
    else
      false
    end
  end

  def approvable?
    if oriented_from == :one
      [:one_deny_two, :two_pending_one].include?(connection.status.to_sym) ? true : false
    elsif oriented_from == :two
      [:two_deny_one, :one_pending_two].include?(connection.status.to_sym) ? true : false
    else
      false
    end
  end

  def user_requested?
    if oriented_from == :one
      connection.one_pending_two? ? true : false
    elsif oriented_from == :two
      connection.two_pending_one? ? true : false
    else
      false
    end
  end

  def friends?
    connection.friends?
  end
  def friends; friends?; end

  def pending?
    [:one_pending_two, :two_pending_one].include?(connection.status.to_sym)
  end
  def pending; pending?; end

  def deleted?
    if connection.one_deny_two?
      oriented_from == :one ? true : false
    elsif connection.two_deny_one?
      oriented_from == :two ? true : false
    else
      false
    end
  end

  def other_name
    if friends? || other_requested?
      other.realname
    else
      other.username
    end
  end

  def treasured?
    unless friends?
      return false
    end

    if oriented_from == :one
      !!connection.two_treasured_at?
    elsif oriented_from == :two
      !!connection.one_treasured_at?
    else
      false
    end
  end
  def treasured; treasured?; end

  protected
    def set_orientation
      if user == connection.user_one
        @other = connection.user_two
        @oriented_from = :one
      else
        @other = connection.user_one
        @oriented_from = :two
      end
    end
end

# enum status: [:one_pending_two, :two_pending_one, :friends, :one_deny_two, :two_deny_one]