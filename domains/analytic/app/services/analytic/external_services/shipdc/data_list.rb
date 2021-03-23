module Analytic
  module ExternalServices
    module Shipdc
      class DataList < Base
        URL = '/ios-op/v2/datalist'.freeze

        def initialize(params)
          super()
          @params = params
        end

        def fetch
          @response = self.class.get(URL, options)
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
