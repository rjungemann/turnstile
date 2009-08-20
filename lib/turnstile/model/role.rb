module Turnstile
  module Model
    class Role
      attr_reader :name

      def initialize name
        @name = name
      end

      def self.init
        $t.db["roles"] ||= {}
      end

      def self.create name, *rights
        raise "Name wasn't provided." if name.nil?
        
        rights ||= []
        roles = $t.db["roles"]

        raise "Role already exists." if roles.include? name

        roles[name] = { :rights => rights }

        $t.db["roles"] = roles

        Role.new name
      end

      def self.find name
        raise "Name wasn't provided." if name.nil?
        
        roles = $t.db["roles"]

        roles.include?(name) ? Role.new(name) : nil
      end
      
      def self.exists? name
        !$t.db["roles"][name].nil?
      end

      def self.roles
        $t.db["roles"].keys
      end

      def rights
        roles = $t.db["roles"]

        roles[@name][:rights]
      end
      
      def has_right? right
        raise "Right wasn't provided." if right.nil?
        
        rights.include? right
      end

      def add_right right
        raise "Right wasn't provided." if right.nil?
        raise "Right already exists." if Role.has_right? right
        
        roles = $t.db["roles"]

        rights = roles[@name][:rights] + right
        roles[@name][:rights] = rights

        $t.db["roles"] = role

        self
      end

      def remove_right right
        raise "Right wasn't provided." if right.nil?
        raise "Right doesn't exist." unless Role.has_right? right
        
        roles = $t.db["roles"]

        rights = roles[@name][:rights].reject right
        roles[@name][:rights] = rights

        $t.db["roles"] = role

        self
      end

      def destroy
        $t.db["roles"].delete @name

        @name = nil

        nil
      end
    end
  end
end