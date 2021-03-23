module Analytic
  module ExternalServices
    module Shipdc
      class MetaDataFind < Base
        URI = '/ios-op/v2/ships/%s/metadata/find'.freeze

        def initialize(imo, params)
          super()
          @imo = imo
          @params = params
        end

        def fetch
          @response = self.class.get("#{format(URI, @imo)}", options)
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
