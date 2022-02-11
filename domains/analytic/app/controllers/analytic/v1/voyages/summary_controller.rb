module Analytic
  module V1
    module Voyages
      class SummaryController < BaseController
        PER_PAGE = 20

        def index
          authorize nil, policy_class: Analytic::Voyages::SummaryPolicy
          scope = Analytic::VoyageSummaryServices::List.new(
            params: summary_params
          ).fetch
          pagy, results = pagy(scope, items: PER_PAGE)
          serializable_hash = VoyageSummarySerializer.new(results).serializable_hash
          pagy_headers_merge(pagy)
          json_response(serializable_hash)
        end

        def show
          summary = Analytic::VoyageSummary.with_edq_resuls.find(params[:id])
          authorize summary, policy_class: Analytic::Voyages::SummaryPolicy
          serializable_hash = VoyageSummarySerializer.new(summary).serializable_hash
          json_response(serializable_hash)
        end

        def export
          authorize nil, policy_class: Analytic::Voyages::SummaryPolicy
          job = Analytic::VoyageSummaryJob::ExportJob.set(wait: 3.seconds).perform_later(summary_params)
          json_response({job_id: job&.job_id})
        end

        def update_manual_fields
          authorize nil, policy_class: Analytic::Voyages::SummaryPolicy
          Analytic::VoyageSummaryForms::UpdateManualFields.new(update_manual_fields_params).call
          json_response({})
        end

        def ports
          allow_params = { arrival: 'arrival_ports', dept: 'dept_ports' }
          data = Analytic::VoyageSummary.send(allow_params[params[:type]])
          json_response(data)
        end

        def summary_params
          params.permit(
            :imo,
            :from_time,
            :to_time,
            :port_dept,
            :port_arrival,
            :voyage_no,
            :voyage_leg,
            :sort_by,
            :sort_order,
            :page
          )
        end

        def update_manual_fields_params
          params.permit(:id,
                        :manual_port_dept,
                        :manual_port_arrival,
                        :manual_atd_lt,
                        :manual_ata_lt,
                        :manual_ata_time_zone,
                        :manual_atd_time_zone,
                        :manual_distance)
        end
      end
    end
  end
end
