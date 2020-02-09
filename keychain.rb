class Keychain
  attr_accessor :url, :username, :password, :slug
  def initialize(params = {})
    @url = params.fetch(:url)
    @username = params.fetch(:username)
    @password = params.fetch(:password)
    @slug = params.fetch(:slug)
  end
end
