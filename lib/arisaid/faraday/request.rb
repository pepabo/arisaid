require 'uri'

module Arisaid
  module Faraday
    class Request < ::Faraday::Middleware
      def response_status
        200
      end

      def response_body
        Sawyer::Resource.new(Sawyer::Agent.new(Breacan.api_endpoint))
      end

      def response_object
        Struct.new(
          :env, :method, :status, :path, :params, :headers, :body, :options)
      end

      def show_request(env)
        unescaped_url = URI.unescape(env.url.to_s)
        puts "#{env.method}: #{Breacan::Error.new.send(:redact_url, unescaped_url)}#{' (no request)' unless requestable?(env)}"
      end

      def stub_out(env)
        response_object.new(
          env, env.method, response_status, env.url, nil, {}, response_body)
      end

      def read?(env)
        unread_pattern = /\.(create|disable|enable|update|setActive|setPresence)\?/
        return env.method == :get && unread_pattern !~ env.url.to_s
      end

      def requestable?(env)
        !Arisaid.read_only? || read?(env)
      end

      def call(env)
        show_request(env) if Arisaid.read_only? || Arisaid.debug?

        if requestable?(env)
          @app.call(env)
        else
          stub_out(env)
        end
      end
    end
  end
end

::Faraday::Request.register_middleware arisaid: -> { ::Arisaid::Faraday::Request }
