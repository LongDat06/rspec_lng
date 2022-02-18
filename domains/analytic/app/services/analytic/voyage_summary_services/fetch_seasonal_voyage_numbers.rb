module Analytic
  module VoyageSummaryServices
    class FetchSeasonalVoyageNumbers < SeasonalVoyageSummary
      MODELING = Struct.new(:id,
                            :imo,
                            :vessel_name,
                            :data,
                            keyword_init: true
                          )
      def call
        check_missing_params
        voyages = fetch_voyages
        response_voyages = {}
        results = []
        return [] if voyages.blank?
        voyages.map do |voyage|
          vessel_name = voyage["vessel_name"]
          response_voyages["#{voyage["imo"]}__#{vessel_name}"] ||= []
          response_voyages["#{voyage["imo"]}__#{vessel_name}"] << {voyage.id => voyage["full_voyage_no"]}
        end
        response_voyages.each do |vessel_info, voyages_no|
          vessel_info = vessel_info.split("__")
          results << MODELING.new(imo: vessel_info.first,
                                  vessel_name: vessel_info.last,
                                  data: voyages_no)
        end
        results
      end
    end
  end
end
