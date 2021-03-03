require 'pit'
require 'io/console'

module Arisaid
  module Dryrun
    prepend Slack::Web::Faraday::Request
  end
end

module Slack
  module Web
    module Faraday
      module Request
        UNREAD_PATTERN = %w(
          create
          disable
          enable
          update
          setActive
          setPresence
        )
        def post(path, options = {})
          if UNREAD_PATTERN.include?(path.to_s.split(".").last)
            puts "post to #{path} :dryrun"
            return true
          end

          request(:post, path, options)
        end

        def put(path, options = {})
          if UNREAD_PATTERN.include?(path.to_s.split(".").last)
            puts "put to #{path} :dryrun"
            return true
          end

          request(:put, path, options)
        end
      end
    end
  end
end
