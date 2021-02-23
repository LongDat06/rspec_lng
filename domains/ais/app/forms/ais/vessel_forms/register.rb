module Ais
  module VesselForms
    class Validation < StandardError; end
    class Register < Base
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
          if vessel.save!
            updated_imo_setting
          end
        end
        vessel.reload
      end

      def updated_imo_setting
        ExternalServices::Csm::ImoRegister.new({
          imos: [vessel.imo]
        }).fetch
      end
    end
  end
end
