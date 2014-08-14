class Master < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 255 }
  validates :database, presence: true, length: { maximum: 50 }
end
