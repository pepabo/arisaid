module Arisaid
  class Guests
    include Arisaid::Client
    include Arisaid::Userable
    include Arisaid::Syncable

    def remote!
      @remote = guests!.map { |user|
        hash = user.to_h.slice(*self.class.user_valid_attributes)
        hash[:real] = user.real_name if user.real_name && !user.real_name.empty?
        hash[:email] = user.profile.email if user.profile.email
        hash.stringify_keys
      }
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
