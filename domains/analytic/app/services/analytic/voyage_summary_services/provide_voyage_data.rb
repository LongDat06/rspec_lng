module Analytic
  module VoyageSummaryServices
    class ProvideVoyageData

      MODELING = Struct.new(
        :imo,
        :voyage_no,
        :voyage_leg,
        keyword_init: true
      )

      def initialize(spas_ids)
        @spas_ids = spas_ids
      end

      def call
        voyage_data.map do |item|
          data = item[:_id]
          MODELING.new(imo: data[:imo],
                       voyage_no: data[:voyage_no],
                       voyage_leg: data[:voyage_leg]
                      )
        end
      end

      private

      def voyage_data
        Analytic::Spas.collection.aggregate([match, group])
      end

      def match
        {
          "$match": {
            "_id": { "$in": @spas_ids }
          }
        }
      end

      def group
        {
          "$group": {
            "_id": { "imo": "$imo_no",
                     "voyage_no": "$spec.jsmea_voy_voyageinformation_voyageno",
                     "voyage_leg": "$spec.jsmea_voy_voyageinformation_leg"
                    }
          }
        }
      end

    end
  end
end
