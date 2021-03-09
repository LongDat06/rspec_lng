module Ais
  module VesselForms
    class ImportNonTarget
      def initialize(imos)
        @imos = imos.uniq.map(&:to_i).reject(&:zero?)
      end

      def create
        create_vessel
      end

      private
      def vessels
        @vessels ||= @imos.map {|imo| { imo: imo, target: false } }
      end

      def create_vessel
        Ais::Vessel.import!(
          vessels, 
          validate: true
        )
        updated_imo_setting
      end

      def updated_imo_setting
        ExternalServices::Csm::ImoRegister.new({
          imos: @imos
        }).fetch
      end
    end
  end
end
