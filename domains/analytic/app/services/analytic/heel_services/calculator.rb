module Analytic
  module HeelServices
    class HeelCalculatorError < StandardError; end
    class Calculator
      CalculatorResult = Struct.new(:etd,
                                    :etd_utc,
                                    :etd_time_zone,
                                    :etd_label,
                                    :eta,
                                    :eta_utc,
                                    :eta_time_zone,
                                    :eta_label,
                                    :estimated_distance,
                                    :voyage_duration,
                                    :required_speed,
                                    :estimated_daily_foc,
                                    :estimated_daily_foc_season_effect,
                                    :estimated_total_foc,
                                    :consuming_lng, :id)



      def initialize(params)
        @submit_params = params
      end

      def call
        CalculatorResult.new(etd,
                             etd_utc,
                             etd_time_zone,
                             etd_label,
                             eta,
                             eta_utc,
                             eta_time_zone,
                             eta_label,
                             estimated_distance,
                             voyage_duration,
                             required_speed,
                             estimated_daily_foc,
                             estimated_daily_foc_season_effect,
                             estimated_total_foc,
                             consuming_lng)
      end

      private
        attr_reader :submit_params
        delegate :imo,
                 :port_dept_id,
                 :port_arrival_id,
                 :master_route_id,
                 :etd,
                 :eta,
                 :foe,
                 :voyage_type, to: :submit_params, private: true


        def fetch_router
          @fetch_router ||= begin
            route = Analytic::Route.select(:distance).find_route(port_dept_id, port_arrival_id, master_route_id)
            raise HeelCalculatorError, I18n.t('analytic.cannot_find_route') if route.nil?

          route
          end
        end

        def port_dept_time_zone
          @port_dept_time_zone ||= Analytic::HeelServices::TimezoneLabel.new(port_id: port_dept_id,
                                                                             time: etd).call
        end

        def port_arrival_time_zone
          @port_arrival_time_zone ||= Analytic::HeelServices::TimezoneLabel.new(port_id: port_arrival_id,
                                                                                time: eta).call
        end

        def eta_time_zone
          port_arrival_time_zone.time_zone
        end

        def eta_utc
          port_arrival_time_zone.time_utc
        end

        def eta_label
          port_arrival_time_zone.label
        end

        def etd_time_zone
          port_dept_time_zone.time_zone
        end

        def etd_utc
          port_dept_time_zone.time_utc
        end

        def etd_label
          port_dept_time_zone.label
        end

        def adjust_time_zone(time, zone)
          time.asctime.in_time_zone(zone)
        end

        def fetch_all_tcp_foc
          @fetch_all_tcp_foc ||= begin
            Analytic::Foc.select(:speed, voyage_type.to_sym).where(imo: imo)
                         .map { |foc| { speed: foc.speed, foc: foc.send(voyage_type) } }
          end
        end

        def estimated_distance
          @estimated_distance ||= fetch_router.distance.round(0)
        end

        def voyage_duration
          @voyage_duration ||= begin
            adjust_time_eta_with_zone = adjust_time_zone(eta, eta_time_zone)
            adjust_time_etd_with_zone = adjust_time_zone(etd, etd_time_zone)
            ((adjust_time_eta_with_zone.to_f - adjust_time_etd_with_zone.to_f)/1.hour).round(0)
          end
        end

        def required_speed
          @required_speed ||= (estimated_distance / voyage_duration.to_f).round(1)
        end

        def estimated_daily_foc
          @estimated_daily_foc ||= begin
            speeds = fetch_all_tcp_foc.pluck(:speed)
            foc = fetch_all_tcp_foc.pluck(:foc)
            estimate = Analytic::InterpolationServices::LinearCalculator.new(x_values: speeds,y_values: foc)
                                                                        .call(x: required_speed)
                                                                        .round(1)
          end
        end

        def estimated_daily_foc_season_effect
          @estimated_daily_foc_season_effect ||= begin
            months_of_winner = [10,11,12,1,2,3]
            if months_of_winner.include? etd.month
              (estimated_daily_foc * 1.1).round(1)
            else
              estimated_daily_foc
            end
          end
        end

        def estimated_total_foc
          @estimated_total_foc ||= (estimated_daily_foc_season_effect * voyage_duration / 24.0).round(0)
        end

        def consuming_lng
          @consuming_lng ||= (estimated_total_foc/foe.to_f).round(0)
        end

    end
  end
end
