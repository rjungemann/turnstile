module Turnstile
  module Model
    module Modules
      module Authorizable
        def authorized? realm, role
          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." if columns[:realms][realm].nil?

          columns[:realms][realm][:roles].include? role
        end

        def add_role realm, role
          raise "Role doesn't exist." if Role.find(role).nil?
          raise "User isn't part of realm." unless in_realm?(realm)
          
          columns = $t.db["user-#{@name}"]
          roles = columns[:realms][realm][:roles]

          raise "User already has this role." if roles.include? role

          roles << role

          columns[:realms][realm][:roles] = roles

          $t.db["user-#{@name}"] = columns
        end

        def remove_role realm, role
          raise "Role doesn't exist." if Role.find(role).nil?
          raise "User isn't part of realm." unless in_realm?(realm)
          
          columns = $t.db["user-#{@name}"]
          roles = columns[:realms][realm][:roles]

          raise "User doesn't have this role." if not roles.include? role

          roles.reject! { |r| r == role }

          columns[:realms][realm][:roles] = roles

          $t.db["user-#{@name}"] = columns
        end

        def roles realm
          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm" unless in_realm?(realm)

          columns[:realms][realm][:roles]
        end
        
        def has_right? realm, right
          not roles(realm).reject { |role|
            not Role.find(role).has_right? role
          }.empty?
        end
      end
    end
  end
end