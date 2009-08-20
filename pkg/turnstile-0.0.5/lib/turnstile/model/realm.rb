module Turnstile
  module Model
    class Realm
      attr_reader :name
      
      def self.init
        $t.db["realms"] ||= {}
      end
      
      def initialize name
        @name = name
      end
      
      def self.create name, *roles
        $t.transact("realms") do |realms|
          realms[name] ||= { :roles => roles || [] }
          
          realms
        end
        
        Realm.new name
      end

      def self.find name
        $t.db["realms"][name] ? Realm.new(name) : nil
      end
      
      def self.exists? name
        !Realm.find(name).nil?
      end

      def add_role name
        raise "Role hasn't been created yet." unless Role.exists? name
        raise "Role already exists in realm." if self.roles.include? name
        
        $t.transact("realms") do |realms|
          realms[@name][:roles] << name
          
          realms
        end
        
        self
      end

      def remove_role name
        raise "Role hasn't been created yet." unless Role.exists? name
        raise "Role already exists in realm." unless self.roles.include? name
        
        $t.transact("realms") do |realms|
          realms[@name][:roles].reject! { |r| r == name }
          
          realms
        end
        
        self
      end
      
      def destroy
        $t.transact("realms") do |realms|
          realms.delete name
          
          realms
        end
        
        nil
      end
      
      def self.realms
        $t.db["realms"]
      end
      
      def roles
        $t.db["realms"][@name][:roles]
      end
    end
  end
end