module Analytic
  module V1
    module Heels
      class TimezoneLabelController < BaseController

        def index
          authorize nil, policy_class: Analytic::Heels::CalculatorPolicy
          result = Analytic::HeelServices::TimezoneLabel.new(time: params[:time],
                                                             port_id: params[:port_id]).call
          json_response(result)
        end

      end
    end
  end
end
