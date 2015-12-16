require 'breacan'
require 'yaml'

require 'arisaid/version'
require 'arisaid/core_ext/hash'
require 'arisaid/configurable'
require 'arisaid/usergroups'

module Arisaid
  class << self
    def read_only?
      true
    end
  end
end
