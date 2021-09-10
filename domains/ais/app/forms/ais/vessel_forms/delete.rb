module Ais
  module VesselForms
    class Delete
      include Wisper::Publisher 

      def initialize(vessel)
        @vessel = vessel
      end

      def call
        Ais::Vessel.transaction do
          if @vessel.destroy!
            remove_imo_setting
            remove_sim
            remove_sim_position
            remove_spas_vessel_destination
          end
        end
      end

      private
      def remove_imo_setting
        ExternalServices::Csm::ImoRemove.new({
          imos: [@vessel.imo]
        }).fetch
      end

      def remove_sim
        return unless @vessel.target
        broadcast(:on_vessel_delete_successful, @vessel.imo)
      end

      def remove_sim_position
        return unless @vessel.target
        Ais::Tracking.where(imo: @vessel.imo, source: :sim).delete_all
      end

      def remove_spas_vessel_destination
        return unless @vessel.target
        Ais::VesselDestination.where(imo: @vessel.imo, source: :spas).delete_all
      end
    end
  end
end
