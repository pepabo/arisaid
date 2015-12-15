require 'arisaid/version'
require 'arisaid/configurable'
require 'breacan'
require 'yaml'

module Arisaid
  class << self
    include Arisaid::Configurable

    def valid_attributes
      %i(
        name
        description
        handle
      )
    end

    def show(slack_team)
      prepare slack_team

      usergroups = Breacan.usergroups
      data = usergroups.map { |usergroup|
        hash = usergroup.to_h.slice(*valid_attributes)
        ids = Breacan.usergroup_users(usergroup.id)
        hash[:users] = ids.empty? ? [] : ids.map { |id| Breacan.user(id).name }
        hash
      }

      puts data.to_yaml
    end

    def apply(slack_team, conf = nil, dryrun = false)
      prepare slack_team

      conf = "#{slack_team}.yml" if conf.nil?
      data = YAML.load_file(conf)
      puts data
    end
  end
end

class Hash
  def slice(*keys)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end
end
