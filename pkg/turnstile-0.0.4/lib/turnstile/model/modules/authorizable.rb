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
          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." unless in_realm?(realm)

          roles = columns[:realms][realm][:roles]

          raise "User already has this role." if roles.include? role

          roles << role

          columns[:realms][realm][:roles] = roles

          $t.db["user-#{@name}"] = columns
        end

        def remove_role realm, role
          columns = $t.db["user-#{@name}"]

          raise "User isn't part of realm." unless in_realm?(realm)

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
      end
    end
  end
end