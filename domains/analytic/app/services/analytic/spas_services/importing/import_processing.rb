module Analytic
  module SpasServices
    module Importing
      class ImportProcessingError < StandardError; end
      class ImportProcessing
        DATA_CLASS = 'RepData'.freeze
        DATA_TYPE = 'AtSeaReport'.freeze

        def initialize(
          imo:, 
          period_time:, 
          rep_data_list_requester: Analytic::ExternalServices::Shipdc::DataList
        )
          @imo = imo
          @period_time = period_time
          @rep_data_list_requester = rep_data_list_requester
        end

        def call
          raise(ImportProcessingError) if datalist.blank?
          import_spas_data
        end

        private
        def import_spas_data
          Analytic::SpasServices::Importing::SpasData.new(
            imo_no: @imo, 
            period_time: @period_time.to_datetime
          ).()
        end

        def datalist
          @datalist ||= begin
            data = @rep_data_list_requester.new({
              from: @period_time.to_datetime.beginning_of_day.strftime('%FT%TZ'),
              to: @period_time.to_datetime.end_of_day.strftime('%FT%TZ')
            }).fetch
            data[:items].select do |item|
              item[:shipId].to_i == @imo &&
              item[:dataClass] == DATA_CLASS &&
              item[:dataType] == DATA_TYPE
            end
          end
        end
      end
    end
  end
end
