module Arisaid
  class Usergroups
    include Arisaid::Client
    include Arisaid::Syncable

    attr_reader :users

    def usergroups
      @usergroups || usergroups!
    end

    def usergroups!
      @usergroups = usergroups_with_disabled!.select { |g| g.deleted_by.nil? }
    end

    def usergroups_with_disabled
      @usergroups_with_disabled || usergroups_with_disabled!
    end

    def usergroups_with_disabled!
      @usergroups_with_disabled =
        client.usergroups(include_users: 1, include_disabled: 1)
    end

    def users
      @users ||= client.users
    end

    def remote!
      @remote = usergroups!.map { |group|
        hash = group.to_h.slice(*self.class.usergroup_valid_attributes)
        hash[:users] = group.users.map { |id| users.find_by(id: id).name }
        hash.stringify_keys
      }
    end

    def apply
      enabled = false

      local.each do |src|
        dst = remote.find_by(name: src['name'])
        next unless dst.nil?

        group = usergroups_with_disabled.find_by(name: src['name'])
        if group
          enable group
          enabled = true
        end
      end

      remote! if enabled

      local.each do |src|
        dst = remote.find_by(name: src['name'])
        case
        when dst.nil? then create src
        when same?(src, dst) then nil
        when changed?(src, dst) then update(src)
        else update_users(src)
        end
      end

      remote.each do |dst|
        src = local.find_by(name: dst['name'])
        disable dst if src.nil?
      end

      nil
    end

    def changed?(src, dst)
      !same?(src, dst) && src['users'] == dst['users']
    end

    def create(src)
      group = client.create_usergroup(
        src.slice(*self.class.usergroup_valid_attributes.map(&:to_s)))
      update_users(nil, group.id)
    end

    def enable(group)
      client.enable_usergroup(usergroup: group.id)
    end

    def disable(dst)
      group = usergroups.find_by(name: dst['name'])
      client.disable_usergroup(usergroup: group.id)
    end

    def update(src)
      group = usergroups.find_by(src['name'])
      data = src.dup
      data[:usergroup] = group.id
      client.update_usergroup(data)
    end

    def update_users(src, group_id = nil)
      group_id = usergroups.find_by(name: src['name']).id if group_id.nil?
      data = {
        usergroup: group_id,
        users: usernames_to_ids(src['users']).join(',')
      }
      client.update_usergroup_users(data)
    end

    def usernames_to_ids(usernames)
      usernames.each.with_object([]) do |username, memo|
        user = users.find_by(name: username)
        memo << user.id if user
      end
    end

    class << self
      def usergroup_valid_attributes
        %i(
          name
          description
          handle
        )
      end
    end
  end
end
