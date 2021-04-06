module Analytic
  module V1
    module Downloads
      class HistoriesController < BaseController
        HISTORY_PER_PAGE = 50
        
        def index
          scope = Analytic::Download
            .imos(params[:imos])
            .where(source: history_params[:source])
            .order_by(created_at: -1)
          vessel_index = Analytic::Vessel.where(imo: scope.pluck(:imo_no).uniq).pluck(:imo, :name).to_h
          pagy, sim_download_histories = pagy_mongoid(scope, items: HISTORY_PER_PAGE)
          sim_download_histories = sim_download_histories.map do |download|
            download.vessel_name = vessel_index[download.imo_no]
            download
          end
          json_histories = Analytic::V1::DownloadSerializer.new(sim_download_histories).serializable_hash
          pagy_headers_merge(pagy)
          json_response(json_histories)
        end

        private
        def history_params
          params.permit(:source, imos: [])
        end
      end
    end
  end
end
