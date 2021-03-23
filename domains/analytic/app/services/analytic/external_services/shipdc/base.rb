module Analytic
  module ExternalServices
    module Shipdc
      class ShipdcDataError < StandardError; end
      class Base
        HTTP_ERRORS = [
          EOFError,
          Errno::ECONNRESET,
          Errno::EINVAL,
          Timeout::Error,
          StandardError,
          JSON::ParserError
        ]

        include HTTParty
        base_uri ENV['LNG_SHIP_DC_API_URI']
        headers 'x-api-key' => ENV['LNG_SHIP_DC_API_KEY']
        headers 'x-sp-app-key' => ENV['LNG_SHIP_DC_SP_APP_KEY']
        headers 'x-su-data-key' => ENV['LNG_SHIP_DC_SU_DATA_KEY']

        attr_accessor :response

        def initialize
          self.class.default_params
          self.class.headers(default_headers)
        end

        def fetch
          begin
            body = JSON.parse(
              response.body,
              symbolize_names: true
            )
            case response.code
              when 200
                body
              when 404
                raise(ShipdcDataError, body)
              when 500...600
                raise(ShipdcDataError, response.code)
            end
          rescue *HTTP_ERRORS => error
            raise(ShipdcDataError, error)
          end
        end

        def options
          Hash(body)
        end

        def body
          {}
        end

        def default_headers
          {
            'Accept' => 'application/json'
          }
        end
      end
    end
  end
end
