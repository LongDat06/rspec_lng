module Analytic
  module V1
    module Edqs
      class ResultController < BaseController
        before_action :get_edq_result, only: [:show, :destroy, :finalize]

        def index
          authorize Analytic::EdqResult, policy_class: Analytic::Edqs::ResultPolicy
          pagy, results = Analytic::EdqServices::Result.new(result_params, current_user.id).fetch
          serializable_hash = ResultSerializer.new(results).serializable_hash
          pagy_headers_merge(pagy)
          json_response(serializable_hash)
        end

        def create
          authorize Analytic::EdqResult, policy_class: Analytic::Edqs::ResultPolicy
          result = Analytic::EdqResultForms::Creation.new(create_params)
          result.author_id = current_user.id
          result.updated_by_id = current_user.id
          result.save!
          json_response({})
        end

        def update
          authorize Analytic::EdqResult, policy_class: Analytic::Edqs::ResultPolicy
          result = Analytic::EdqResultForms::Update.new(update_params)
          result.updated_by_id = current_user.id
          result.save!
          json_response({})
        end

        def show
          authorize @edq_result, policy_class: Analytic::Edqs::ResultPolicy
          serializable_hash = ResultSerializer.new(@edq_result).serializable_hash
          json_response(serializable_hash)
        end

        def destroy
          authorize @edq_result, policy_class: Analytic::Edqs::ResultPolicy
          @edq_result.destroy!
          json_response({})
        end

        def finalize
          authorize @edq_result, policy_class: Analytic::Edqs::ResultPolicy
          Analytic::EdqServices::Finalization.new(edq_result: @edq_result).call
          json_response({})
        end

        private

        def result_params
          params.permit(:imo,
                        :ballast_voyage_port_dept_id,
                        :ballast_voyage_port_arrival_id,
                        :laden_voyage_port_dept_id,
                        :laden_voyage_port_arrival_id,
                        :voyage_no,
                        :voyage_no_type,
                        :master_route_id,
                        :master_route_type,
                        :sort_by,
                        :sort_order,
                        :page)
        end

        def create_params
          params.permit(:imo,
                        :name,
                        :foe,
                        :laden_voyage_no,
                        :ballast_voyage_no,
                        :init_lng_volume,
                        :unpumpable,
                        :cosuming_lng_of_laden_voyage,
                        :heel,
                        :edq,
                        laden_voyage: heel_voyage_params,
                        ballast_voyage: heel_voyage_params)
        end

        def heel_voyage_params
          [:port_dept_id, :port_arrival_id, :master_route_id,
           :etd, :etd_time_zone, :eta, :eta_time_zone, :estimated_distance,
           :voyage_duration, :required_speed, :estimated_daily_foc,
           :estimated_daily_foc_season_effect, :estimated_total_foc,
           :consuming_lng]
        end

        def update_params
          create_params.merge(id: params[:id])
        end

        def get_edq_result
          @edq_result = Analytic::EdqResult.find(params[:id])
        end

      end
    end
  end
end
