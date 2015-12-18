require 'breacan'
require 'yaml'

require 'arisaid/version'
require 'arisaid/core_ext/hash'
require 'arisaid/core_ext/array'
require 'arisaid/error'
require 'arisaid/configurable'
require 'arisaid/client'
require 'arisaid/syncable'
require 'arisaid/usergroups'
require 'arisaid/users'

module Arisaid
  class << self
    include Arisaid::Configurable

    def usergroups(team = '')
      @usergroups ||= Usergroups.new(team)
    end

    def users(team = '')
      @users ||= Users.new(team)
    end
  end
end
