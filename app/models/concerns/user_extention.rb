require 'digest/sha2'
require 'digest/hmac'

module UserExtention
  extend ActiveSupport::Concern
  
  included do
    validates :password, length: { minimum: 6 }, if: :password
  
    # Password confirmation only validate when both password and
    # password_confirmation are not nil.
    validates :password, confirmation: true,
      if: Proc.new { !@password.nil? && !password_confirmation.nil? }
    validates :password_confirmation, presence: false
    
  end
  
  module ClassMethods
    def sha256_hash(value, salt = nil)
      salt = SecureRandom.urlsafe_base64(6) if salt.nil?
      hashed = Digest::HMAC.hexdigest(value, salt, Digest::SHA256)
      "SHA256:%s$%s" % [salt, hashed]
    end
  end
  
  def password
    @password
  end

  def password=(value)
    if value.present?
      self.hashed_password = self.class.sha256_hash(value)
      @password = value
    else
      self.hashed_password = nil
    end
  end

  def challenge_password(passwd)
    return false if self.hashed_password.nil?
  
    hash_name, salt, hash = self.hashed_password.split(/\:|\$/)
    return false if hash_name != "SHA256"
  
    self.hashed_password == self.class.sha256_hash(passwd, salt)
  end
  
  def create_hashed_message(*args, salt: nil)
    args.push Rails.application.secrets[:secret_key_base]
    basestr = args.map { |e| 
      e.instance_of?(Symbol) ? self[e] : e
    } .join(',')
    
    self.class.sha256_hash(basestr, salt)[7..-1]
  end
end
