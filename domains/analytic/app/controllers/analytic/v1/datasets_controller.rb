module Analytic
  module V1
    class DatasetsController < BaseController
      def index
        dataset ||= Analytic::ExternalServices::Shipdc::DataSet.new.fetch
        datatypes = dataset[:iosData].select {|item| item[:shipId] == params[:imo].to_s}
                    .map {|item| item[:dataType]}.uniq.sort

        json_response(datatypes.presence || [Analytic::Sim::DEFAULT_DATA_TYPE])
      end
    end
  end
end
