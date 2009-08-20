module Turnstile
  module Model
    module Modules
      module Authorizable
        def authorized? realm, role
          raise "Realm wasn't provided." if realm.nil?
          raise "Role wasn't provided." if role.nil?
          raise "Role doesn't exist." unless Role.exists? role
          raise "Realm doesn't exist." unless Realm.exists? realm
          raise "User isn't part of realm." unless in_realm?(realm)
          
          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." if columns[:realms][realm].nil?

          columns[:realms][realm][:roles].include? role
        end

        def add_role realm, role
          raise "Realm wasn't provided." if realm.nil?
          raise "Role wasn't provided." if role.nil?
          raise "Role doesn't exist." unless Role.exists? role
          raise "Realm doesn't exist." unless Realm.exists? realm
          raise "User isn't part of realm." unless in_realm?(realm)
          
          columns = $t.db["user-#{@name}"]
          roles = columns[:realms][realm][:roles]

          raise "User already has this role." if roles.include? role

          roles << role

          columns[:realms][realm][:roles] = roles

          $t.db["user-#{@name}"] = columns
        end

        def remove_role realm, role
          raise "Realm wasn't provided." if realm.nil?
          raise "Role wasn't provided." if role.nil?
          raise "Role doesn't exist." unless Role.exists? role
          raise "Realm doesn't exist." unless Realm.exists? realm
          raise "User isn't part of realm." unless in_realm?(realm)
          
          columns = $t.db["user-#{@name}"]
          roles = columns[:realms][realm][:roles]

          raise "User doesn't have this role." if not roles.include? role

          roles.reject! { |r| r == role }

          columns[:realms][realm][:roles] = roles

          $t.db["user-#{@name}"] = columns
        end

        def roles realm
          raise "Realm wasn't provided." if realm.nil?
          raise "Realm doesn't exist." unless Realm.exists? realm
          
          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm" unless in_realm?(realm)

          columns[:realms][realm][:roles]
        end
        
        def has_right? realm, right
          raise "Realm wasn't provided." if realm.nil?
          raise "Right wasn't provided." if right.nil?
          raise "Realm doesn't exist." unless Realm.exists? realm
          raise "User isn't part of realm." unless in_realm?(realm)
          
          not roles(realm).reject { |role|
            not Role.find(role).has_right? role
          }.empty?
        end
      end
    end
  end
end