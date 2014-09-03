class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  before_destroy :check_last_admin
  
  def check_last_admin
    if admin && !User.exists?(['id!=? and admin=?',id,true]) 
      errors.add :base, 'Cannot delete all admins users'
      return false
    end
  end
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  #has_many :services, dependent: :destroy

  has_many :user_masters, dependent: :destroy
  has_many :masters, through: :user_masters
  
  

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.name = auth.info.name
      user.email = auth.uid+'@facebook.com'
      user.save!
    end
  end
  
  def master_access m
    admin or masters.exists?(m)
  end
  
  def masters
    admin? ? Master.all : super
  end
    
  
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)    
    end
end
