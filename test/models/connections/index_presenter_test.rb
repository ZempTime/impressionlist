require 'test_helper'

class Connections::IndexPresenterTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_1)
  end

  test "treasured" do
    ip = Connections::IndexPresenter.new(@user)
    assert_equal [connections(:c1_treasure_2).id], ip.treasured.map { |c| c.connection.id }
  end
  test "active" do
    ip = Connections::IndexPresenter.new(@user)
    assert_equal [connections(:c1_accept_2).id, connections(:c2_treasure_1).id], ip.active.map { |c| c.connection.id }
  end
  test "pending" do
    ip = Connections::IndexPresenter.new(@user)
    assert_equal [connections(:c1_pending_2).id, connections(:c2_pending_1).id], ip.pending.map { |c| c.connection.id }
  end
  test "deleted" do
    ip = Connections::IndexPresenter.new(@user)
    assert_equal [connections(:c1_deny_2).id], ip.deleted.map { |c| c.connection.id }
  end
end