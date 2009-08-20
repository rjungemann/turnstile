require 'moneta'
require 'moneta/sdbm'

module Turnstile
  module Model
    class Turnstile
      attr_reader :db
      
      def self.init
        User.init
        Realm.init
        Role.init
      end
    
      def initialize(options = {})
        options[:path] ||= File.join(File.dirname(__FILE__), "..", "tmp", "db.sdbm")
        options[:moneta_store] ||= Moneta::SDBM
      
        @db = options[:moneta_store].new(:file => options[:path])
      end
    
      def transact(key, &block)
        item = @db[key] || {}
        @db[key] = yield(item)
      end
    end
  end
end