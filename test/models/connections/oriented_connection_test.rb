
require 'test_helper'

class Connections::OrientedConnectionTest < ActiveSupport::TestCase
  def setup
    @user_1 = users(:user_1)
    @user_2 = users(:user_2)
    @user_3 = users(:user_3)
    @user_4 = users(:user_4)
    @user_5 = users(:user_5)
    @user_6 = users(:user_6)
    @user_7 = users(:user_7)
    @user_8 = users(:user_8)

    @c1_pending_2 = connections(:c1_pending_2) # 1 2
    @c2_pending_1 = connections(:c2_pending_1) # 1 3
    @cfriends = connections(:c1_accept_2) # 1 4
    @c1_deny_2 = connections(:c1_deny_2) # 1 5
    @c2_deny_1 = connections(:c2_deny_1) # 1 6
    @c1_treasure_2 = connections(:c1_treasure_2)
    @c2_treasure_1 = connections(:c2_treasure_1)
  end

  # attrs
  test "sets user" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)

    assert_equal oc.user, @user_1
  end
  test "sets connection" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)
    assert_equal @c1_pending_2, oc.connection
  end
  test "sets other" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)
    assert_equal @user_2, oc.other
  end
  test "sets oriented_from" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)
    assert_equal :one, oc.oriented_from
  end

  # user_requested?
  test "user_requested true when user :one, connection :one_pending_two" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)
    assert oc.user_requested?
  end
  test "user_requested true when user :two, connection :two_pending_one" do
    oc = Connections::OrientedConnection.new(@user_3, @c2_pending_1)
    assert oc.user_requested?
  end
  test "user_requested is false otherwise" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.user_requested?
  end

  # other_requested?
  test "other_requested true when user :one, connection :two_pending_one" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_pending_1)
    assert oc.other_requested?
  end
  test "other_requested true when user :two, connection :one_pending_two" do
    oc = Connections::OrientedConnection.new(@user_3, @c1_pending_2)
    assert oc.other_requested?
  end
  test "other_requested false otherwise" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.other_requested?
  end

  # friends?
  test "friends returns true when connection friends" do
    oc = Connections::OrientedConnection.new(@user_3, @cfriends)
    assert oc.friends?
  end
  test "friends returns false when connection not friends" do
    oc = Connections::OrientedConnection.new(@user_3, @c2_deny_1)
    refute oc.friends?
  end

  # pending?
  test "pending? true when :one_pending_two" do 
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)
    assert oc.pending?
  end
  test "pending? true when :two_pending_one" do 
    oc = Connections::OrientedConnection.new(@user_3, @c2_pending_1)
    assert oc.pending?
  end
  test "pending? false when otherwise" do 
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.pending?
  end

  # deleted?
  test "deleted? true when user :two and :two_deny_one" do
    oc = Connections::OrientedConnection.new(@user_3, @c2_deny_1)
    assert oc.deleted?
  end
  test "deleted? false when user :one and :two_deny_one" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.deleted?
  end
  test "deleted? true when user :one and :one_deny_two" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_deny_2)
    assert oc.deleted?
  end
  test "deleted? false when user :two and :one_deny_two" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.deleted?
  end
  test "deleted? false otherwise" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_pending_2)
    refute oc.deleted?
  end

  # other_name
  test "other_name returns realname when other requested" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_pending_1)
    assert_equal @user_3.realname, oc.other_name
  end
  test "other_name returns user name when not other requested" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    assert_equal @user_6.username, oc.other_name
  end

  # treasured?
  test "treasured true when user :one, friends, and two_treasured_at" do
    oc = Connections::OrientedConnection.new(@user_1, @c1_treasure_2)
    assert oc.treasured?
  end
  test "treasured true when user :two, friends, and one_treasured_at" do
    oc = Connections::OrientedConnection.new(@user_8, @c2_treasure_1)
    assert oc.treasured?
  end
  test "treasured false when not friends" do
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.treasured?
  end
  test "treasured false when not friends even if treasured_at set" do
    @c2_deny_1.two_treasured_at = DateTime.now()
    oc = Connections::OrientedConnection.new(@user_1, @c2_deny_1)
    refute oc.treasured?
  end
end