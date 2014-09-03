class UserMaster < ActiveRecord::Base
  belongs_to :user
  belongs_to :master
  validates :user, presence: true;
  validates :master, presence: true;
  
end
