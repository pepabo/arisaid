require 'pit'
require 'io/console'

module Arisaid
  module Configurable
    OPTIONS_KEYS = %i(
      debug
      read_only
      slack_team
      slack_token
      save_token
      conf_prefix
      exit_status
    )

    attr_accessor(*OPTIONS_KEYS)

    def self.extended(base)
      base.reset
    end

    def reset
      self.debug       = false
      self.read_only   = true
      self.save_token  = false
      self.conf_prefix = nil
      self.exit_status = 0
    end

    def options
      OPTIONS_KEYS.inject({}) { |o, k| o.merge!(k => send(k)) }
    end

    def configure
      yield self
    end

    def debug?
      @debug ||= false
    end

    def read_only?
      @read_only ||= false
    end

    def save_token?
      @save_token ||= false
    end

    def slack_team
      ENV['BREACAN_TEAM'] ||= ask_slack_team
    end

    def slack_team=(team)
      ENV['BREACAN_TEAM'] = team
    end

    def ask_slack_team
      $stdout.print 'Slack Team: '
      $stdin.gets.gsub(/\n/, '')
    end

    def slack_token
      ENV['BREACAN_ACCESS_TOKEN'] ||= slack_token!
    end

    def slack_token!
      token = slack_token_by_pit

      if token.nil?
        token = ask_slack_token
        save_slack_token_by_pit(token) if save_token?
      end

      token
    end

    def ask_slack_token
      $stdout.print 'Slack Token(https://api.slack.com/web): '
      $stdin.noecho(&:gets).tap{ $stdout.print "\n" }.gsub(/\n/, '')
    end

    def save_slack_token_by_pit(token)
      self.pit= if pit.is_a?(Hash)
          pit.merge(slack_team => token)
        else
          { slack_team => token }
        end
    end

    def pit
      Pit.get('arisaid')
    end

    def pit=(data)
      Pit.set('arisaid', data: data)
    end

    def slack_token_by_pit
      pit[slack_team]
    end
  end
end
