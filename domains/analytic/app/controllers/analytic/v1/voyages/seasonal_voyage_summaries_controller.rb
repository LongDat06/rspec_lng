module Analytic
  module V1
    module Voyages
      class SeasonalVoyageSummariesController < BaseController
        def index
          voyages, chart = Analytic::VoyageSummaryServices::SeasonalVoyageSummary.new(
            imos: params[:imos],
            dept_ports: params[:dept_ports],
            arrival_ports: params[:arrival_ports],
            dept_years: params[:dept_years],
            dept_months: params[:dept_months],
            voyage_ids: params[:voyage_ids]
          ).()

          serializable_voyages = SeasonalVoyageSummarySerializer.new(voyages).serializable_hash
          serializable_chart = Analytic::V1::Charts::VoyageSummary::SeasonalSummarySerializer.new(chart).serializable_hash
          json_response({filter_voyages: serializable_voyages, voyages_chart: serializable_chart})
        end

        def fetch_voyage_numbers
          voyages = Analytic::VoyageSummaryServices::FetchSeasonalVoyageNumbers.new(
            imos: params[:imos],
            dept_ports: params[:dept_ports],
            arrival_ports: params[:arrival_ports],
            dept_years: params[:dept_years],
            dept_months: params[:dept_months],
            voyage_ids: params[:voyage_ids]
          ).()

          serializable_voyages = SeasonalVoyageNumberSerializer.new(voyages).serializable_hash
          json_response(serializable_voyages)
        end

        def fetch_arrival_ports
          json_response(Analytic::VoyageSummary.arrival_ports)
        end

        def fetch_departure_ports
          json_response(Analytic::VoyageSummary.departure_ports)
        end
      end
    end
  end
end
