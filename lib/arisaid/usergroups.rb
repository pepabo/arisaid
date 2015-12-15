module Arisaid
  class Usergroups
    include Arisaid::Configurable
    attr_writer :local_file

    def local_file
      @local_file ||= "#{slack_team}.ussergroups.yml"
    end

    def remote
      attrs = self.class.valid_attributes
      Breacan.usergroups.map { |group|
        hash = group.to_h.slice(*attrs)
        ids = Breacan.usergroup_users(group.id)
        hash[:users] = ids.empty? ? [] : ids.map { |id| Breacan.user(id).name }
        hash.stringify_keys
      }
    end

    def local
      YAML.load_file(local_file)
    end

    def initialize
      prepare
    end

    def show
      puts remote.to_yaml
    end

    def apply
      puts local
    end

    class << self
      def valid_attributes
        %i(
          name
          description
          handle
        )
      end
    end
  end
end
