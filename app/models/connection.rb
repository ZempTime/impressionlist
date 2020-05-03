class Connection < ApplicationRecord
  belongs_to :user_one, class_name: "User", foreign_key: :user_one_id, required: true
  belongs_to :user_two, class_name: "User", foreign_key: :user_two_id, required: true

  # treasured_at isnt the person doing the treasuring, but the person being treasured
  # so if user_one "treasures" user_two, two_treasured_at has a date of when that happened

  enum status: [:one_pending_two, :two_pending_one, :friends, :one_deny_two, :two_deny_one]

  validate :idempotent_id_writes

  def self.connection_for(user_one, user_two)
    id1 = user_one.try(:id) ? user_one.id : user_one
    id2 = user_two.try(:id) ? user_two.id : user_two

    ids = [id1, id2].sort
    user_one_id = ids[0]
    user_two_id = ids[1]

    self.where("user_one_id = ? AND user_two_id = ?", user_one_id, user_two_id)
  end

  def self.connection_for?(user_one, user_two)
    !!self.connection_for(user_one, user_two)
  end

  def append_log(msg)
    if log.nil?
      log = msg
    else
      log = "#{log} #{msg}"
    end
  end

  # create
  # approve
  # deny
  # treasure

  # logging

  private
    def idempotent_id_writes
      if user_one_id > user_two_id
        errors.add(:user_one_id, "cannot be larger than user_two_id")
      end
    end
end