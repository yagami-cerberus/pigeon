class ApiKey < ActiveRecord::Base
  belongs_to :user

  def self.create(user)
    ApiKey.create!(:user => user, :key => SecureRandom.urlsafe_base64(8), :secret_key => SecureRandom.urlsafe_base64(36))
  end
end
