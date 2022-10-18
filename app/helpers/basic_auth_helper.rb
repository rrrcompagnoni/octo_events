module BasicAuthHelper
  def self.user
    ENV['BASIC_AUTH_USER']
  end

  def self.password
    ENV['BASIC_AUTH_PASSWORD']
  end
end
