class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def connections
    Connection.where("user_one_id = ? OR user_two_id = ?", self.id, self.id)
  end
end
