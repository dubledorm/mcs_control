require 'securerandom'

module GeneratePassword
  def self.generate_password(length)
    SecureRandom.base64(length)
  end
end
