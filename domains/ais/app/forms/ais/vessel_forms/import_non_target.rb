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
        @vessels ||= @imos.map {|imo| {imo: imo, target: false } }
      end

      def create_vessel
        opts = Ais::Vessel.import!(
          [:imo, :target], vessels, validate: false, on_duplicate_key_ignore: true
        )
        updated_imo_setting(Ais::Vessel.where(id: opts.ids).pluck(:imo))
      end

      def updated_imo_setting(new_imo)
        ExternalServices::Csm::ImoRegister.new({
          imos: new_imo
        }).fetch
      end
    end
  end
end
