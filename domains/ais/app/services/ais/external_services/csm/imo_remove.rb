module Ais
  module ExternalServices
    module Csm
      class ImoRemove < Base
        URI = '/v1/vessels/list'.freeze

        def initialize(params)
          super()
          @params = params
        end

        def fetch
          @response = self.class.delete("#{URI}", options)
          super
        end

        def body
          {
            timeout: 300,
            verify: false,
            body: @params
          }
        end
      end
    end
  end
end
