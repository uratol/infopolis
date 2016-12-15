class Master < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 255 }
  validates :database, presence: true, length: { maximum: 50 }
  has_many :user_masters
  has_many :users, through: :user_masters 

end


