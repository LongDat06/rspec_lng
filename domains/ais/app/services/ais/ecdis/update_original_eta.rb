module Ais
  module Ecdis
    class UpdateOriginalEta
      def initialize(points)
        @points = points
      end

      def call 
        update_original_eta
      end

      private
      def update_original_eta
        Ais::EcdisPoint.import ecdis_points, on_duplicate_key_update: {conflict_target: [:id], columns: [:original_eta]}
      end

      def ecdis_points
        @points.map { |point| { id: point[:id], original_eta: point[:original_eta].to_datetime } }
      end
    end
  end
end
