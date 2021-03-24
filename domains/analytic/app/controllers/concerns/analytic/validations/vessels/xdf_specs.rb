module Analytic
  module Validations
    module Vessels
      class XdfSpecs
        include ActiveModel::Validations
        attr_accessor :imo, :time

        validates_presence_of :imo, :time

        def initialize(params)
          @imo = params[:imo]
          @time = params[:time]
        end
      end
    end
  end
end
