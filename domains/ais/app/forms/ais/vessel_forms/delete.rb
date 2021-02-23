module Ais
  module VesselForms
    class Delete
      def initialize(vessel)
        @vessel = vessel
      end

      def call
        if @vessel.destroy!
          remove_imo_setting
        end
      end

      private
      def remove_imo_setting
        ExternalServices::Csm::ImoRemove.new({
          imos: [@vessel.imo]
        }).fetch
      end
    end
  end
end
