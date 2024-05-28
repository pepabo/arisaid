module Arisaid
  module Userable
    attr_reader :users, :guests, :bots

    def users
      @users ||= users!
    end

    def users!
      @users = all_users.select { |u|
        u.deleted == false && u.is_bot == false && u.is_restricted == false
      }
    end

    def guests
      @guests ||= guests!
    end

    def guests!
      @guests = all_users.select { |u|
        u.deleted == false && u.is_bot == false && u.is_restricted == true
      }
    end

    def bots
      @bots ||= bots!
    end

    def bots!
      @bots = all_users.select { |u|
        u.deleted == false && u.is_bot == true && u.is_restricted == false
      }
    end

    def all_users
      all_users = []
      client.users_list(presence: true, max_retries: 20) do |response|
        all_users.concat(response.members)
      end
      all_users
    end
  end
end
