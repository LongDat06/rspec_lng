module Analytic
  module V1
    module Heels
      class CalculatorController < BaseController

        def create
          authorize nil, policy_class: Analytic::Heels::CalculatorPolicy
          result = Analytic::HeelCalculatorForms::Submission.new(submission_params).()
          serializable_hash = Analytic::V1::Heels::CalculatorSerializer.new(result).serializable_hash
          json_response(serializable_hash)
        end

        private
        def submission_params
          params.permit(:imo, :port_dept, :port_arrival, :pacific_route, :etd, :eta, :foe, :voyage_type)
        end
      end
    end
  end
end
