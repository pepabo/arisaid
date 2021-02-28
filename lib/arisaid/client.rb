require 'arisaid/faraday/request'
require 'arisaid/faraday/response'

module Arisaid
  module Client
    def client
      @client ||= client!
    end

    def client!
      Arisaid.slack_team
      Arisaid.slack_token

      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end

      Slack::Web::Client.new
    end
  end
end
