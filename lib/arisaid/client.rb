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

      Breacan.setup
      Breacan.configure do |config|
        config.middleware = ::Faraday::RackBuilder.new do |c|
          c.request :arisaid
          c.response :arisaid
          c.response :breacan_custom
          c.adapter ::Faraday.default_adapter
        end
      end
      Breacan
    end
  end
end
