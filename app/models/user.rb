class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation
  has_secure_password

  before_create :generate_remember_token

  def generate_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
