module Ais
  module VesselForms
    class Validation < StandardError; end
    class Register < Base
      include Wisper::Publisher

      def create
        if valid?
          create_vessel
        else
          raise(Validation, errors.full_messages.join(', '))
        end
      end

      private
      def vessel
        @vessel ||= Ais::Vessel.new
      end

      def create_vessel
        Ais::Vessel.transaction do
          vessel.assign_attributes(attributes.except(:id))
          vessel.last_port_departure_at = 2.month.ago
          if vessel.save!
            updated_imo_setting
            update_vessel_name
          end
        end
        start_import_sim
        vessel.reload
      end

      def updated_imo_setting
        ExternalServices::Csm::ImoRegister.new({
          imos: [vessel.imo]
        }).fetch
      end

      def update_vessel_name
        Ais::SyncServices::VesselInformation.new([vessel.imo]).()
      end

      def start_import_sim
        return unless @vessel.target
        broadcast(:on_vessel_create_successful, @vessel.imo, @vessel.sim_data_type)
      end
    end
  end
end
