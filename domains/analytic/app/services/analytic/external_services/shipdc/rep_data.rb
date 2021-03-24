module Analytic
  module ExternalServices
    module Shipdc
      class RepData < Base
        URL = '/ios-op/v2/ships/%s/rep-data'.freeze

        def initialize(imo, params)
          super()
          @imo = imo
          @params = params
        end

        def fetch
          @response = self.class.get("#{format(URL, @imo)}", options)
          super
        end

        def body
          {
            timeout: 300,
            verify: false,
            query: @params
          }
        end
      end
    end
  end
end
