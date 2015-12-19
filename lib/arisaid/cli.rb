require 'arisaid'
require 'thor'

module Arisaid
  class CLI < Thor
    RESOURCES = %w(
        users
        usergroups
      )

    option :team, type: :string, aliases: '-t', desc: 'slack team'
    option :token, type: :string, aliases: '-p', desc: 'slack token'
    option :debug, type: :boolean, aliases: '-d', desc: 'debug'
    desc 'show [RESOURCE]', "show #{RESOURCES.join(', ')}"
    def show(resource)
      Arisaid.debug = true if options[:debug]
      Arisaid.send(:"#{resource}", options[:team]).show
    end

    option :team, type: :string, aliases: '-t', desc: 'slack team'
    option :token, type: :string, aliases: '-p', desc: 'slack token'
    option :debug, type: :boolean, aliases: '-d', desc: 'debug'
    desc 'save [RESOURCE]', "save #{RESOURCES.join(', ')}"
    def save(resource)
      Arisaid.debug = true if options[:debug]
      Arisaid.send(:"#{resource}", options[:team]).save
    end

    option :team, type: :string, aliases: '-t', desc: 'slack team'
    option :token, type: :string, aliases: '-p', desc: 'slack token'
    option :debug, type: :boolean, aliases: '-d', desc: 'debug'
    option :dryrun, type: :boolean, aliases: '-n', desc: 'dry run'
    desc 'apply [RESOURCE]', "apply #{RESOURCES.join(', ')}"
    def apply(resource)
      Arisaid.read_only = true if options[:dryrun]
      Arisaid.debug = true if options[:debug]
      Arisaid.send(:"#{resource}", options[:team]).apply
    end
  end
end
