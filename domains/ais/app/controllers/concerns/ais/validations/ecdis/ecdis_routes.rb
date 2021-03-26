module Ais
  module Validations
    module Ecdis
      class EcdisRoutes
        include ActiveModel::Validations
        attr_accessor :imo, :time, :ecdis_route_ids

        validates_length_of :ecdis_route_ids, maximum: 2, allow_blank: true

        def initialize(params)
          @imo = params[:imo]
          @time = params[:time]
          @ecdis_route_ids = params[:ecdis_route_ids]
        end
      end
    end
  end
end
