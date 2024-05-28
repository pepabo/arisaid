module Arisaid
  class Bots
    include Arisaid::Client
    include Arisaid::Userable
    include Arisaid::Syncable

    def remote!
      @remote = bots!.map { |user|
        hash = user.to_h.slice(*self.class.bot_valid_attributes)
        hash[:real] = user.real_name if user.real_name && !user.real_name.empty?
        hash.stringify_keys
      }
    end

    class << self
      def bot_valid_attributes
        %w(
          name
        )
      end
    end
  end
end
