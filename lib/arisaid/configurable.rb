require 'pit'

module Arisaid
  module Configurable
    def prepare(team_name)
      self.team = team_name
      self.access_token
      Breacan.setup
    end

    def team
      ENV['BREACAN_TEAM']
    end

    def team=(name)
      ENV['BREACAN_TEAM'] = name
    end

    def access_token
      ENV['BREACAN_ACCESS_TOKEN'] ||= access_token_by_pit
    end

    def access_token_by_pit
      Pit.get('arisaid', require: {
        team => "#{team} Access Token? (https://api.slack.com/web)"
      })[team]
    end
  end
end
