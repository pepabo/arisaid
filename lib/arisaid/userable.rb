module Arisaid
  module Userable
    attr_reader :users

    def users
      @users || users!
    end

    def users!
      @users = client.users.select { |u|
        u.deleted == false && u.is_bot == false
      }
    end
  end
end
