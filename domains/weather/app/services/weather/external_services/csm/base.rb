module Weather
  module ExternalServices
    module Csm
      class CsmDataError < StandardError; end
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
        base_uri ENV['LNG_CSM_OPEN_API_URI']
        headers 'Access-Token' => ENV['LNG_CSM_OPEN_API_TOKEN']

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
                raise(CsmDataError, body[:message])
              when 500...600
                raise(CsmDataError, "ZOMG ERROR #{response.code}")
            end
          rescue *HTTP_ERRORS => error
            raise(CsmDataError, error)
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
