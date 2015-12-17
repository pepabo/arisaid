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
        escaped_url = env.url.to_s
        unescaped_url = URI.unescape(escaped_url)
        puts "#{env.method}: #{unescaped_url.gsub(/token=[a-z0-9\-]*/, "token=#{'*'*10}")}"
      end

      def stub_out(env)
        response_object.new(
          env, env.method, response_status, env.url, nil, {}, response_body)
      end

      def call(env)
        show_request(env) if Arisaid.read_only? || Arisaid.debug?

        if !Arisaid.read_only? || env.method == :get
          @app.call(env)
        else
          stub_out(env)
        end
      end
    end
  end
end

::Faraday::Request.register_middleware arisaid: -> { ::Arisaid::Faraday::Request }
