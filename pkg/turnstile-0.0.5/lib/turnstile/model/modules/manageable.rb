require 'andand'

module Turnstile
  module Model
    module Modules
      module Manageable
        module ClassMethods
          def find name
            $t.db.has_key?("user-#{name}") ? User.new(name) : nil
          end

          def create name
            raise "No name was provided." if name.nil?
            
            $t.transact("user-#{name}") do |user|
              raise "User already exists" unless user.empty?

              { :name => name, :realms => {}, :created_on => Time.now }
            end
            
            User.new name
          end
          
          def exists? name
            !User.find(name).nil?
          end

          def users
            $t.db.keys.reject { |k| not k.match(/user-.*/) }.collect { |k| k[5..-1] }
          end

          def realms
            $t.db["realms"].andand.keys
          end
        end
        
        def add_realm realm, password
          raise "No password was provided." if password.nil?
          raise "No realm was provided." if realm.nil?
          raise "Realm doesn't exist." if Realm.find(realm).nil?

          columns = $t.db["user-#{@name}"]

          salt = Generate.salt

          raise "User is already part of this realm." if not columns[:realms][realm].nil?

          columns[:realms][realm] = { :roles => [] }
          columns[:realms][realm][:salt] = salt
          columns[:realms][realm][:hash] = Generate.hash(salt, password)

          $t.db["user-#{name}"] = columns

          self
        end

        def remove_realm realm
          raise "No realm was provided." if realm.nil?
          raise "Realm doesn't exist." if Realm.find(realm).nil?

          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." if not in_realm?(realm)

          columns[:realms].delete realm

          $t.db["user-#{name}"] = columns

          self
        end

        def in_realm? realm
          !$t.db["user-#{@name}"][:realms][realm].nil?
        end

        def change_password realm, password
          raise "No password was provided." if password.nil?
          raise "No realm was provided." if realm.nil?

          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." if not in_realm?(realm)

          salt = Generate.salt

          columns[:realms][realm][:salt] = salt
          columns[:realms][realm][:hash] = Generate.hash(salt, password)

          $t.db["user-#{@name}"] = columns

          self
        end

        def check_password realm, password
          raise "No password was provided." if password.nil?
          raise "No realm was provided." if realm.nil?

          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." if not in_realm?(realm)

          hash = Generate.hash(columns[:realms][realm][:salt], password)

          hash == columns[:realms][realm][:hash]
        end

        def realms
          columns = $t.db["user-#{@name}"][:realms].keys
        end

        def destroy
          $t.db.delete "user-#{@name}"

          @name = nil

          nil
        end
        
        def self.included(base)
          base.extend ClassMethods
        end
      end
    end
  end
end