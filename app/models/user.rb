class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :set_default_list
  has_one :list

  def connections
    Connection.where("user_one_id = ? OR user_two_id = ?", self.id, self.id)
  end

  def set_default_list
    list = List.new
    self.list = list
  end
end
