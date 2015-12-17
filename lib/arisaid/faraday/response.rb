module Arisaid
  module Faraday
    class Response < ::Faraday::Middleware
      def call(env)
        @app.call(env).on_complete do |v|
          if Arisaid.debug? && defined?(AwesomePrint)
            require 'awesome_print'
            ap v.response.to_hash.slice(*valid_debug_attributes)
          end
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
