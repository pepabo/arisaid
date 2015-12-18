module Arisaid
  module Faraday
    class Response < ::Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |_env|
          show_response(_env) if Arisaid.debug? && defined?(AwesomePrint)
        end
      end

      def show_response(env)
        require 'awesome_print'

        env.response.to_hash.slice(*valid_debug_attributes).each do |k, v|
          if k == :body
            k = :response_body
            v = Sawyer::Agent.serializer.decode(v)
          end

          puts "#{k}:"
          ap v
        end
      end

      def valid_debug_attributes
        %i(
          status
          body
          response_headers
        )
      end
    end
  end
end

::Faraday::Response.register_middleware arisaid: -> { ::Arisaid::Faraday::Response }
