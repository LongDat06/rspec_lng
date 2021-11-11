module Analytic
  module V1
    module Vessels
      class GenresController < BaseController
        include Wisper::Publisher

        def index
          results = Analytic::Genre.active.select(:id, :name)
                                  .where(imo: params[:vessel_imo])
                                  .order(:name)
          json_response(results.as_json(only: [:id, :name]))
        end

        def export_mapping
           url = Analytic::GenreServices::Exporting::GenreChannelCurrentMappingCsv.new(imo: params[:vessel_imo]).()
           json_response({ url: url })
        end

        def export_errors
          vessel = Analytic::Vessel.find_by(imo: params[:vessel_imo])
          url = vessel&.genre_error_reporting&.url
          json_response({ url: url })
        end

        def import
          Analytic::GenreJob::GenreImportJob.perform_later(params[:vessel_imo], import_params)
          broadcast(:on_proccessing_genre_import, params[:vessel_imo])
          json_response({})
        end

        private
        def import_params
          params.permit(:id, :storage, metadata:[:filename, :size, :mime_type])
        end

      end
    end
  end
end
