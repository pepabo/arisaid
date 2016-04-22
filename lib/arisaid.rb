require 'breacan'
require 'yaml'
require 'thor'

require 'arisaid/version'
require 'arisaid/core_ext/hash'
require 'arisaid/core_ext/array'
require 'arisaid/error'
require 'arisaid/configurable'
require 'arisaid/client'
require 'arisaid/userable'
require 'arisaid/syncable'
require 'arisaid/usergroups'
require 'arisaid/users'
require 'arisaid/guests'
require 'arisaid/bots'
require 'arisaid/cli'

module Arisaid
  class << self
    include Arisaid::Configurable

    def usergroups(team = '')
      @usergroups ||= Usergroups.new(team)
    end

    def users(team = '')
      @users ||= Users.new(team)
    end

    def guests(team = '')
      @guests ||= Guests.new(team)
    end

    def bots(team = '')
      @bots ||= Bots.new(team)
    end
  end
end
