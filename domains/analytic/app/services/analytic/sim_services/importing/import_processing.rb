module Analytic
  module SimServices
    module Importing
      class ImportProcessingError < StandardError; end
      class ImportProcessing
        DATA_CLASS = 'IoSData'.freeze
        DATA_TYPE = 'ShipData'.freeze

        def initialize(
          imo:, 
          period_from:,
          period_to:,
          ios_data_list_requester: Analytic::ExternalServices::Shipdc::DataList
        )
          @imo = imo
          @period_from = period_from
          @period_to = period_to
          @ios_data_list_requester = ios_data_list_requester
        end

        def call
          raise(ImportProcessingError) if datalist.blank?
          import_sim_data
        end

        private
        def import_sim_data
          Analytic::SimServices::Importing::SimData.new(
            imo_no: @imo, 
            period_from: @period_from,
            period_to: @period_to
          ).()
        end

        def datalist
          @datalist ||= begin
            data = @ios_data_list_requester.new({
              from: @period_from.strftime('%FT%TZ'),
              to: @period_to.strftime('%FT%TZ')
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
