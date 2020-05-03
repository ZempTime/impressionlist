require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "connection_for looks up by two ids" do
    user1 = users(:user_1)
    user2 = users(:user_2)

    conn = Connection.connection_for(user2, user1).first
    assert_equal connections(:c1_pending_2), conn
  end

  test "idempotent id writes" do
    user9 = users(:user_9)
    user8 = users(:user_8)
    connection = Connection.new
    connection.user_one_id = user9.id
    connection.user_two_id = user8.id
    refute connection.valid?
  end
end