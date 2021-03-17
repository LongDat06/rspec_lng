module Ais
  module UtilityServices
    class LatLonConverter
      def self.ddm_to_dd(ddm)
        dds = ddm.split(/ /)
        return nil unless dds.present? && dds.length == 3
        
        dd = dds[0].to_f + dds[1].to_f / 60
        return dd unless dds[2] != 'S' && dds[2] != 'W'

        -dd
      end

      def self.dd_calculator(d, m, h)
        return nil unless d.present? && m.present? && h.present?

        dd = d.to_f + m.to_f / 60
        return dd unless h != 'S' && h != 'W'

        -dd
      end
    end
  end
end
