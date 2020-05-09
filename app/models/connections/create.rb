class Connections::Create
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :current_user, :other_user_email, :other_user, :user_one_id, :user_two_id, :connection

  validate :other_user_exists
  validate :no_existing_connection
  validates_presence_of :other_user_email, :current_user

  def save
    set_other_user

    if valid?
      save_connection
    else
      false
    end
  end

  def save_connection
    id1 = current_user.id
    id2 = other_user.id

    ids = [id1, id2].sort
    @user_one_id = ids[0]
    @user_two_id = ids[1]
    status = current_user.id == user_one_id ? :one_pending_two : :two_pending_one

    @connection = Connection.new(user_one_id: @user_one_id, user_two_id: @user_two_id, status: status)

    if @connection.save
      return true
    else
      return false
    end
  end

  protected
    def set_other_user
      @other_user = User.where(email: other_user_email).first
    end

    def other_user_exists
      if !other_user
        errors.add(:base, "Unable to create a connection with specified email")
      end
    end

    def no_existing_connection
      return unless other_user

      if Connection.connection_for(current_user, other_user).any?
        errors.add(:base, "Unable to create a connection with specified email")
      end
    end
end