module Analytic
  module ExternalServices
    module Shipdc
      class MetaData < Base
        URI = '/ios-op/v2/ships/%s/metadata'.freeze

        def initialize(imo)
          super()
          @imo = imo
        end

        def fetch
          @response = self.class.get("#{format(URI, @imo)}", options)
          super
        end

        def body
          {
            timeout: default_timeout,
            verify: false
          }
        end
      end
    end
  end
end
