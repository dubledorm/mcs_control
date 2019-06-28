require 'securerandom'

module GeneratePassword
  def generate_password(length)
    SecureRandom.base64(length)
  end
end
