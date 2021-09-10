module Analytic
  module ExternalServices
    module Shipdc
      class DataSet < Base
        URL = '/ios-op/v1/dataset'.freeze

        def initialize
          super()
        end

        def fetch
          @response = self.class.get(URL, options)
          super
        end

        def body
          {
            timeout: default_timeout,
            verify: false,
          }
        end
      end
    end
  end
end
