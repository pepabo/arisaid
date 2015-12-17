module Arisaid
  class Usergroups
    include Arisaid::Client

    attr_writer :local_file
    attr_reader :usergroups_users, :users

    def local_file
      @local_file ||= "#{Arisaid.conf_prefix if Arisaid.conf_prefix}usergroups.yml"
    end

    def local_file_path
      File.join(Dir.pwd, local_file)
    end

    def remote
      @remote ||= remote!
    end

    def usergroups
      @usergroups ||= client.usergroups
    end

    def usergroup_users(id)
      @usergroups_users["#{id}"] ||= client.usergroup_users(id)
    end

    def user(id)
      users.find { |u| u.id == id }
    end

    def users
      @users ||= client.users
    end

    def remote!
      usergroups.map { |group|
        hash = group.to_h.slice(*self.class.usergroup_valid_attributes)
        ids = usergroup_users(group.id)
        hash[:users] = ids.empty? ? [] : ids.map { |id| user(id).name }
        hash.stringify_keys
      }
    end

    def local
      local_by_stdin || local_by_file
    end

    def local_by_stdin
      if File.pipe?(STDIN) || File.select([STDIN], [], [], 0) != nil
        buffer = ''
        while str = STDIN.gets
          buffer << str
        end
        buffer.chomp
      end
    end

    def local_by_file
      unless File.exists?(local_file_path)
        raise Arisaid::ConfNotFound.new("Not found: #{local_file_path}")
      end
      YAML.load_file(local_file_path)
    end

    def initialize(team = nil)
      @usergroups_users = {}
      Arisaid.slack_team = team
    end

    def show
      puts remote.to_yaml
    end

    def apply
      local.each do |src|
        dst = remote.find { |d| src['name'] == d['name'] }

        case
        when dst.nil? then create src
        when same?(src, dst) then nil
        when changed?(src, dst) then update(src, dst)
        else update_users(src, dst)
        end
      end

      remote.each do |dst|
        src = local.find { |l| dst['name'] == l['name'] }
        disable dst if src.nil?
      end

      nil
    end

    def same?(src, dst)
      src == dst
    end

    def changed?(src, dst)
      !same?(src, dst) && src['users'] == dst['users']
    end

    def create(src)
      group = client.create_usergroup src.slice(*self.class.usergroup_valid_attributes.map(&:to_s))
      data = {
        usergroup: group.id,
        users: usernames_to_ids(src['users']).join(',')
      }
      client.update_usergroup_users(data)
    end

    def disable(dst)
      group = usergroups.find { |g| g.name == dst['name'] }
      client.disable_usergroup(usergroup: group.id)
    end

    def update(src, dst)
      group = usergroups.find { |g| g.name == src['name'] }
      data = src.dup
      data[:usergroup] = group.id
      client.update_usergroup(data)
    end

    def update_users(src, dst)
      group = usergroups.find { |g| g.name == src['name'] }
      data = {
        usergroup: group.id,
        users: usernames_to_ids(src['users']).join(',')
      }
      client.update_usergroup_users(data)
    end

    def usernames_to_ids(usernames)
      usernames.each.with_object([]) do |username, memo|
        user = users.find { |u| u.name == username }
        memo << user.id if user
      end
    end

    def save
      File.write local_file_path, remote.to_yaml
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
