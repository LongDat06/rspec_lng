module Analytic
  module V1
    module Management
      class FocsController < BaseController
        before_action :set_foc, only: [:update, :destroy]
        before_action :add_authorize, only: [:index, :create, :import, :fetch_invalid_record_file, :export]

        def index
          focs = Analytic::ManagementServices::FocService.new(params[:imo], params[:sort_by], params[:sort_order]).()
          pagy, focs = pagy(focs, items: PER_PAGE)
          focs_json = Analytic::V1::Management::FocSerializer.new(focs).serializable_hash
          pagy_headers_merge(pagy)
          json_response(focs_json)
        end

        def create
          Analytic::Foc.create!(create_params)
          json_response({})
        end

        def update
          @foc.update!(update_params)
          json_response({})
        end

        def destroy
          @foc.destroy!
          json_response({})
        end

        def import
          metadata = uploader
          Analytic::ManagementJob::ImportingFocJob.perform_later(metadata, current_user.id)
          json_response({})
        end

        def fetch_invalid_record_file
          url = Analytic::ReportFile.fetch_report_url(Analytic::ReportFile::FOC)
          json_response({url: url})
        end

        def export
          Analytic::ManagementJob::ExportingFocJob.perform_later(current_user.id, params[:imo], params[:sort_by], params[:sort_order])
          json_response({})
        end

        private

        def set_foc
          @foc = Analytic::Foc.find(params[:id])
          authorize @foc
        end

        def add_authorize
          authorize Analytic::Foc
        end

        def create_params
          foc_params = params.permit(:imo, :speed, :laden, :ballast)
          foc_params.merge!(updated_by: current_user, created_by: current_user)
        end

        def update_params
          params.permit(:laden, :ballast).merge!(updated_by: current_user)
        end
      end
    end
  end
end