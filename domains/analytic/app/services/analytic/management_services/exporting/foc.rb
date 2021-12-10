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
          ['Imo', 'Speed (kts)', 'Laden FOC (MT/ day)', 'Ballast FOC (MT/ day)']
        end

        def rows
          focs = Analytic::ManagementServices::FocService.new(imo, sort_by, sort_order).()
          focs.pluck(:imo, :speed, :laden, :ballast)
        end

        def file_name
          "exported_foc_#{Time.current.utc.strftime('%FT-%H-%M-%S')}.xlsx"
        end
      end
    end
  end
end
