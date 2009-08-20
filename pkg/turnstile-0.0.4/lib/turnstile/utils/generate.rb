require 'digest/sha2'
require 'uuid'

class Generate
  @@uuid = UUID.new
  
  def self.salt
    [Array.new(6) { rand(256).chr }.join].pack('m').chomp
  end
  
  def self.hash password, salt
    Digest::SHA256.hexdigest password + salt
  end
  
  def self.uuid
    @@uuid.generate
  end
end