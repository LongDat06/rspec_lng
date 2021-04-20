module Ais
  module VesselForms
    class ImportNonTarget
      attr_accessor :invalid_imos

      def initialize(imos)
        @imos = imos
        @imos_valid = []
        @invalid_imos = []
      end

      def create
        process_imo
        import_instance = create_vessel
        updated_imo_setting(Ais::Vessel.where(id: import_instance.ids).pluck(:imo))
        if import_instance.failed_instances.present?
          @invalid_imos.concat(import_instance.failed_instances.map {|_, value| value.imo })
        end
      end

      private
      def vessels
        @vessels ||= @imos_valid.map {|imo| { imo: imo, target: false } }
      end

      def process_imo
        @imos.uniq.each do |imo|
          imo.to_i.zero? ? @invalid_imos << imo : @imos_valid << imo
        end
      end

      def create_vessel
        Ais::Vessel.import(
          [:imo, :target], vessels, validate: true, on_duplicate_key_ignore: true, track_validation_failures: true
        )
      end

      def updated_imo_setting(new_imo)
        ExternalServices::Csm::ImoRegister.new({
          imos: new_imo
        }).fetch
      end
    end
  end
end
