module Arisaid
  module Userable
    attr_reader :users, :guests, :bots

    def users
      @users ||= users!
    end

    def users!
      @users = client.users[:members].select { |u|
        u.deleted == false && u.is_bot == false && u.is_restricted == false
      }
    end

    def guests
      @guests ||= guests!
    end

    def guests!
      @guests = client.users[:members].select { |u|
        u.deleted == false && u.is_bot == false && u.is_restricted == true
      }
    end

    def bots
      @bots ||= bots!
    end

    def bots!
      @bots = client.users[:members].select { |u|
        u.deleted == false && u.is_bot == true && u.is_restricted == false
      }
    end
  end
end
