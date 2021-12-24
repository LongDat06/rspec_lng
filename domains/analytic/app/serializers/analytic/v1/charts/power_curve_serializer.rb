module Analytic
  module V1
    module Charts
      class PowerCurveSerializer
        include FastJsonapi::ObjectSerializer

        attributes :tcp_curve_points,
                   :tcp_plan_points,
                   :actual_fitting_curve_points,
                   :actual_plot_points
      end
    end
  end
end
