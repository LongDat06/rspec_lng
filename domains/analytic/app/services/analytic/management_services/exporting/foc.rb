module Analytic
  module ManagementServices
    module Exporting
      class Foc < Base
        attr_reader :imo, :sort_by, :sort_order
        def initialize(imo, sort_by, sort_order)
          @imo = imo
          @sort_by = sort_by
          @sort_order = sort_order
        end

        def header
          ['IMO', 'Speed (knot)', 'Laden FOC (MT/day)', 'Ballast FOC (MT/day)']
        end

        def rows
          focs = Analytic::ManagementServices::FocService.new(imo, sort_by, sort_order).()
          focs.pluck(:imo, :speed, :laden, :ballast)
        end

        def file_name
          return "exported_foc_#{Time.current.utc.strftime('%FT-%H-%M-%S')}.xlsx" if imo.blank?
          vessel_name = Analytic::Vessel.find_by_imo(imo)&.name
          "#{vessel_name}_exported_foc_#{Time.current.utc.strftime('%FT-%H-%M-%S')}.xlsx"
        end
      end
    end
  end
end
