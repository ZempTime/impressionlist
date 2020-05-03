class Connections::IndexPresenter
  attr_reader :user, :connections

  def initialize(user)
    @user = user
    @connections = @user.connections.map { |connection| Connections::OrientedConnection.new(@user, connection)}
  end

  def treasured
    connections.select(&:treasured?)
  end

  def active
    connections.select(&:friends?).reject(&:treasured?)
  end

  def pending
    connections.select(&:pending?)
  end

  def deleted
    connections.select(&:deleted?)
  end
end