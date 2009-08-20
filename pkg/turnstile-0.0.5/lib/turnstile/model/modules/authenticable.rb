module Turnstile
  module Model
    module Modules
      module Authenticable
        module ClassMethods
          def signin(realm, name, password)
            raise "No name was provided." if name.nil?
            raise "No password was provided." if password.nil?
            raise "No realm was provided." if realm.nil?

            user = User.find name

            if user.nil?
              return nil
            else
              raise "User isn't part of realm." if not user.in_realm?(realm)
              raise "Wrong password was provided." if !user.check_password(realm, password)

              uuid = Generate.uuid

              user.set_uuid uuid, realm

              return user
            end
          end

          def from_uuid(uuid)
            raise "No uuid was provided." if uuid.nil?

            uuids = $t.db["uuids"]

            name, realm = uuids[uuid][:name], uuids[uuid][:realm]

            user = User.find name

            user.in_realm?(realm) ? user : nil
          end
        end

        def signout(realm)
          raise "No realm was provided." if realm.nil?
          raise "User isn't part of realm." if not in_realm?(realm)

          set_uuid nil, realm

          nil
        end

        def signedin?(realm)
          $t.db["user-#{@name}"][:realms][realm].andand[:uuid].nil? ? nil : self
        end

        def uuid(realm)
          $t.db["user-#{@name}"][:realms][realm][:uuid]
        end

        def set_uuid(uuid, realm)
          uuids = $t.db["uuids"]
          uuids[uuid] = { :name => self.name, :realm => realm }
          $t.db["uuids"] = uuids

          $t.transact("user-#{@name}") do |u|
            u[:realms][realm][:uuid] = uuid
            u
          end
        end

        def self.included(base)
          base.extend ClassMethods
        end
      end
    end
  end
end