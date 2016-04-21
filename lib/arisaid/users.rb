module Arisaid
  class Users
    include Arisaid::Client
    include Arisaid::Userable
    include Arisaid::Syncable

    def remote!
      @remote = users!.map { |user|
        hash = user.to_h.slice(*self.class.user_valid_attributes)
        hash[:real] = user.profile.first_name if user.profile.first_name
        hash[:email] = user.profile.email if user.profile.email
        hash.stringify_keys
      }
    end

    def apply
    end

    class << self
      def user_valid_attributes
        %i(
          name
        )
      end
    end
  end
end
