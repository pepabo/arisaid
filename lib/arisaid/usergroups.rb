module Arisaid
  class Usergroups
    include Arisaid::Client
    include Arisaid::Userable
    include Arisaid::Syncable

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
        client.usergroups_list(include_users: true, include_disabled: true).usergroups
    end

    def remote!
      @remote = usergroups!.map { |group|
        hash = group.to_h.symbolize_keys.slice(*self.class.usergroup_valid_attributes)
        hash[:users] = group.users ? group.users.map { |id| users.find_by(id: id).name rescue nil } : {}
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

      if Arisaid.read_only?
        local.each do |src|
          dst = remote.find_by(name: src['name'])

          if dst.nil?
            puts "create usergroup: #{src['name']}"
            puts "  + description: #{src['description']}"
            src['users'].flatten.each do |user|
              puts "  + user #{user}"
            end

            next
          end

          next if same?(src, dst)

          if changed?(src, dst) || users_changed?(src, dst)
            puts "update usergroup: #{src['name']}"
          end

          if users_changed?(src, dst)
            add = src['users'].flatten.compact.sort  - dst['users'].flatten.compact.sort
            delete = dst['users'].flatten.compact.sort - src['users'].flatten.compact.sort
            add.each do |u|
              puts "  + user #{u}"
            end
            delete.each do |u|
              puts "  - user #{u}"
            end
          end
        end

        remote.each do |dst|
          src = local.find_by(name: dst['name'])
          puts "disable #{dst['name']}" if src.nil?
        end
      end

      local.each do |src|
        dst = remote.find_by(name: src['name'])
        case
        when dst.nil? then create src
        when same?(src, dst) then nil
        when changed?(src, dst) then update(src)
        else
          usergroup = usergroups.find_by(name: src['name'])
          update_users(usergroup.id, src)
        end
      end if !(enabled && Arisaid.read_only?)

      remote.each do |dst|
        src = local.find_by(name: dst['name'])
        disable dst if src.nil?
      end

      nil
    end

    def same?(src, dst)
      src['name'] == dst['name'] &&
          src['description'] == dst['description'] &&
          src['handle'] == dst['handle'] &&
          src['users'].flatten.compact.sort == dst['users'].flatten.compact.sort
    end

    def changed?(src, dst)
      !same?(src, dst) && src['users'] == dst['users']
    end

    def users_changed?(src, dst)
      src['users'].flatten.compact.sort != dst['users'].flatten.compact.sort
    end

    def description_changed?(src, dst)
      src['description'] != dst['description']
    end

    def create(src)
      group = client.usergroups_create(src.symbolize_keys.reject {|key| key == :users})
      update_users(group.usergroups.id, src) if group.respond_to?(:usergroups)
    end

    def enable(group)
      client.usergroups_enable(usergroup: group.id)
    end

    def disable(dst)
      group = usergroups.find_by(name: dst['name'])
      client.usergroups_disable(usergroup: group.id)
    end

    def update(src)
      group = usergroups.find_by(name: src['name'])
      data = src.dup
      data['usergroup'] = group.id
      data.delete('users') unless data['users'].nil?
      client.usergroups_update(data)
    end

    def update_users(group_id, src)
      data = {
        usergroup: group_id,
        users: usernames_to_ids(src['users']).join(',')
      }
      client.usergroups_users_update(data)
    end

    def usernames_to_ids(usernames)
      usernames.each.with_object([]) do |username, memo|
        user = users.find_by(name: username)
        if user
          memo << user.id
        else
          puts "#{'user not found:'.colorize(:red)} #{username}"
          Arisaid.exit_status = 1
        end
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
