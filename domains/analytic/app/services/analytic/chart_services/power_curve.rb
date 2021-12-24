module Analytic
  module ChartServices
    class PowerCurve
      MODELING = Struct.new(
        :id,
        :tcp_curve_points,
        :tcp_plan_points,
        :actual_fitting_curve_points,
        :actual_plot_points,
        keyword_init: true
      )
      def initialize(voyage_summary_id:, margin_drop:)
        @voyage_summary_id = voyage_summary_id
        @margin_drop = margin_drop.to_f
      end

      def call
        MODELING.new(
          tcp_curve_points: tcp_curve_points,
          tcp_plan_points: tcp_plan_points,
          actual_fitting_curve_points: actual_fitting_curve_points,
          actual_plot_points: actual_plot_points
        )
      end

      private

      def tcp_curve_points
        x_values = tcp_speed_extend_range
        x_values.map { |x| point_calc(tcp_curve_quadratic_formula, x) }
      end

      def tcp_plan_points
        x_values = tcp_speed_extend_range
        x_values.map { |x| point_calc(plan_curve_quadratic_formula, x) }
      end

      def actual_plot_points
        actual_speed_and_actual_foc.map { |item| [item[:actual_speed], item[:actual_foc]] }
      end

      def actual_fitting_curve_points
        return [] if adjusted_speeds.nil?

        tcp_speed_extend_range.map { |x| point_calc(actual_fitting_curve_quadratic_formula, x) }
      end

      def actual_speed_and_actual_foc
        return [] if closest_sim_data.nil?

        @actual_speed_and_actual_foc ||= closest_sim_data.map do |item|
          {
            actual_speed: item['actual_speed'],
            actual_foc: item['actual_foc']
          }
        end
      end

      def avg_gap
        @avg_gap ||= begin
          arr = []
          actual_speed_and_actual_foc.each do |item|
            gap = gap_calc(item[:actual_speed], item[:actual_foc])
            arr << gap if gap.present?
          end
          return if arr.blank?

          (arr.sum / arr.length).to_f
        end
      end

      def adjusted_speeds
        return if avg_gap.nil?

        @adjusted_speeds ||= tcp_speed.map { |speed| (speed.to_d * (1 - avg_gap.to_d)).to_f }
      end

      def closest_sim_data
        project = {
          "$project": {
            actual_speed: '$spec.jsmea_nav_gnss_sog',
            actual_foc: { "$cond": [engine_xdf?,
                                    '$spec.jsmea_mac_ship_total_include_gcu_fc',
                                    { "$add": [{ '$convert': { input: '$spec.jsmea_mac_boiler_fgline_fg_flowcounter_fgc',
                                                               to: 'double', onError: nil } },
                                               { '$convert': { input: '$spec.jsmea_mac_boiler_total_flowcounter_foc',
                                                               to: 'double', onError: nil } }] }] }
          }
        }
        group = {
          '$group' => {
            '_id' => { 'hour' => { '$hour' => '$spec.ts' }, 'day' => { '$dayOfMonth' => '$spec.ts' },
                       'month' => { '$month' => '$spec.ts' }, 'year' => { '$year' => '$spec.ts' } },
            'spec' => { '$last' => '$spec' }
          }
        }
        Analytic::VoyageSummaryServices::ProvideVoyageClosestData.new(imo: imo,
                                                                      ata: ata,
                                                                      atd: atd,
                                                                      project: project,
                                                                      group: group).call
      end

      def gap_calc(actual_speed, actual_foc)
        return if actual_speed.blank? || actual_foc.blank?

        a = tcp_curve_quadratic_formula.a.to_s.to_d
        b = tcp_curve_quadratic_formula.b.to_s.to_d
        c = (tcp_curve_quadratic_formula.c.to_s.to_d - actual_foc.to_s.to_d)
        d = b**2 - 4 * a * c
        return nil if d < 0

        x1 = (-b + Math.sqrt(d)) / (2 * a)
        x2 = (-b - Math.sqrt(d)) / (2 * a)
        max_x = [x1, x2].max
        (1 - (max_x / actual_speed.to_s.to_d)).to_f
      end

      def tcp_foc_data
        @tcp_foc_data ||= vessel.focs.select(:speed, voyage_type).order(:speed)
      end

      def tcp_speed
        @tcp_speed ||= tcp_foc_data.map(&:speed)
      end

      def tcp_speed_extend_range
        @tcp_speed_extend_range ||= begin
          min = tcp_speed.first
          max = tcp_speed.last
          [min - 1, min - 0.5] + tcp_speed + [max + 0.5, max + 1]
        end
      end

      def tcp_foc
        @tcp_foc ||= tcp_foc_data.map(&voyage_type)
      end

      def drop_speed
        @drop_speed ||= tcp_speed.map { |x| (x.to_s.to_d * (1 - @margin_drop.to_s.to_d)).to_f }
      end

      def tcp_curve_quadratic_formula
        @tcp_curve_quadratic_formula ||= begin
          x_values = tcp_speed
          y_values = tcp_foc
          Analytic::RegressionServices::QuadraticCalculator.new(x_values: x_values, y_values: y_values).call
        end
      end

      def plan_curve_quadratic_formula
        @plan_curve_quadratic_formula ||= begin
          x_values = drop_speed
          y_values = tcp_foc
          Analytic::RegressionServices::QuadraticCalculator.new(x_values: x_values, y_values: y_values).call
        end
      end

      def actual_fitting_curve_quadratic_formula
        @actual_fitting_curve_quadratic_formula ||= begin
          x_values = adjusted_speeds
          y_values = tcp_foc
          Analytic::RegressionServices::QuadraticCalculator.new(x_values: x_values, y_values: y_values).call
        end
      end

      def point_calc(quadratic_formula, x)
        y = (quadratic_formula.a.to_s.to_d * x.to_s.to_d**2 + (quadratic_formula.b.to_s.to_d * x.to_s.to_d) + quadratic_formula.c.to_s.to_d).to_f
        [x, y]
      end

      def voyage_summary
        @voyage_summary ||= Analytic::VoyageSummary.find(@voyage_summary_id)
      end

      def voyage_type
        voyage_summary.voyage_leg == 'B' ? :ballast : :laden
      end

      def imo
        voyage_summary.imo
      end

      def ata
        voyage_summary.ata_utc
      end

      def atd
        voyage_summary.atd_utc
      end

      def vessel
        @vessel ||= Analytic::Vessel.find_by(imo: imo)
      end

      def engine_xdf?
        vessel.engine_type.xdf?
      end
    end
  end
end
