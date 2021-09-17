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
          params[:column_mappings] = fetch_channels
          params.permit(:timestamp_from_at, :timestamp_to_at, :included_stdname, column_mappings: {}, imos: [])
        end

        def fetch_channels
          Analytic::SimServices::Channels.new(
            params: {
              imo: params[:imos]&.first,
              channels: params[:is_select_all].to_s == 'true' ? nil : params[:channels],
              except_channels: params[:except_channels]
            }
          ).call.each_with_object({}) { |sim, hash| hash[sim.id.to_s] = sim.local_name }
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
