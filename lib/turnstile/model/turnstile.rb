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
        tmp_dir = File.join(File.dirname(__FILE__), "..", "tmp")
        Dir.mkdirs(tmp_dir) unless File.directory?(tmp_dir)
        
        options[:path] ||= File.join(tmp_dir, "db.sdbm")
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