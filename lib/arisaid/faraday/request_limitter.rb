module Arisaid
  module Faraday
    class RequestLimitter < ::Faraday::Middleware
      def mocking(env)
        puts "#{env.method} #{env.url}: #{env.body}"
        env.status = 200
        env.body = {}
        env.instance_eval do
          def headers; {} end
          def env; {} end
        end
        env
      end

      def call(env)
        if !Arisaid.read_only? || env.method == :get
          @app.call(env)
        else
          mocking(env)
        end
      end
    end
  end
end

::Faraday::Request.register_middleware limitter: -> { ::Arisaid::Faraday::RequestLimitter }
