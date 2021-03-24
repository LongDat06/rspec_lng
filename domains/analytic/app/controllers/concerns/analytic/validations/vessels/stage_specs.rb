module Analytic
  module Validations
    module Vessels
      class StageSpecs
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
