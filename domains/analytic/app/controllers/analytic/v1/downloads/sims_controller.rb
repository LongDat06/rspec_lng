module Analytic
  module V1
    module Downloads
      class SimsControllerInvalidParameters < ActionController::BadRequest; end
      class SimsController < BaseController
        before_action :validate_params, only: [:create]

        def create
          Analytic::DownloadServices::SimJobCreated.new(
            params: download_params,
            current_user_id: current_user.id
          ).()

          Analytic::SimJob::QueueNextJob.perform_later
          json_response({})
        end

        private
        def download_params
          column_mappings = {}
          params[:column_mappings].each do |key, value|
            column_mappings[key] = value if params[:channels].include?(key)
          end
          params[:column_mappings] = column_mappings
          params.permit(:timestamp_from_at, :timestamp_to_at, :included_stdname, column_mappings: {}, imos: [])
        end

        def validate_params
          sim_download_validation = Analytic::Validations::SimDownload.new(download_params)
          unless sim_download_validation.valid?
            raise(
              SimsControllerInvalidParameters, 
              sim_download_validation.errors.full_messages.to_sentence
            )
          end
        end
      end
    end
  end
end
