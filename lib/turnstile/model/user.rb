dir = File.dirname(__FILE__)

require "#{dir}/modules/manageable"
require "#{dir}/modules/authenticable"
require "#{dir}/modules/authorizable"

module Turnstile
  module Model
    class User
      include Modules::Manageable
      include Modules::Authenticable
      include Modules::Authorizable

      attr_accessor :name
    
      def self.init
        $t.db["uuids"] ||= {}
      end
    
      def initialize(name = nil)
        @name = name
      end
    end
  end
end